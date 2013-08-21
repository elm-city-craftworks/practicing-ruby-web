class ArticlesController < ApplicationController
  before_filter :find_article, :only => [:show, :edit, :update, :share]
  before_filter :create_visit, :only => [:show]
  before_filter :update_url, :only => [:show]


  skip_before_filter :authenticate,      :only => [:shared, :samples]
  skip_before_filter :authenticate_user, :only => [:shared, :samples]

  def index
    if params[:volume]
      @group = VolumeDecorator.find_by_number(params[:volume].to_i)
    elsif params[:collection]
      @group = CollectionDecorator.find_by_slug(params[:collection])
    else
      return redirect_to library_path
    end

    unless @group.model
      render_http_error 404
    else
      @collections = CollectionDecorator.decorate(Collection.order("position"))
      @volumes     = VolumeDecorator.decorate(Volume.order("number"))

      @articles = @group.articles.order("published_time")
      @articles = @articles.published unless current_user.try(:admin)

      @articles = @articles.paginate(:page => params[:page], :per_page => 8)
      @articles = ArticleDecorator.decorate(@articles)
    end
  end

  def show
    mixpanel.track("Article Visit", :title   => @article.subject,
                                    :user_id => current_user.hashed_id)

    authenticate_admin if @article.status == "draft"

    @comments = CommentDecorator.decorate(@article.comments.order("created_at"))

    decorate_article
  end

  def share
    @share = SharedArticle.find_or_create_by_article_id_and_user_id(
      @article.id, current_user.id)

    mixpanel.track("Article Shared", :title   => @article.subject,
                                     :user_id => current_user.hashed_id)

    respond_to do |format|
      format.html
      format.json do
        render :json => shared_article_url(@share.secret).to_json
      end
    end
  end

  def shared
    @share = SharedArticle.find_by_secret(params[:secret])

    unless @share
      render_http_error 404
    else
      mixpanel.track("Shared Article Visit", :title     => @share.article.subject,
                                             :shared_by => @share.user.hashed_id)
      @share.viewed unless current_user
      @user    = UserDecorator.decorate(@share.user)
      @article = @share.article
      decorate_article
    end
  end

  def samples
    redirect_to "/"
  end

  def random
    redirect_to Article.where(:status => "published").sample
  end

  private

  def find_article
    @article = Article[params[:id]]

    render_http_error(404) unless @article
  end

  # NOTE: This method uses our custom override of article_path in ApplicationHelper

  def update_url
    slug_needs_updating = @article.slug.present? && params[:id] != @article.slug
    missing_token       = params[:u].blank?

    redirect_to(article_path(@article)) if slug_needs_updating || missing_token
  end

  def decorate_article
    @article = ArticleDecorator.decorate(@article)
  end

  def authenticate_admin
    raise unless current_user.admin
  end

  def create_visit
    article_visit = ArticleVisit.where(:user_id => current_user.id,
      :article_id => @article.id)

    if article_visit.any?
      article_visit.first.viewed
    else
      article_visit.create
    end
  end
end

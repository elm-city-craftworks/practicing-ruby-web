class ArticlesController < ApplicationController
  before_filter :find_article, :only => [:show, :edit, :update, :share]
  before_filter :update_url, :only => [:show]
  before_filter :validate_token, :only => [:show]

  skip_before_filter :authenticate,      :only => [:show, :shared, :samples]
  skip_before_filter :authenticate_user, :only => [:show, :shared, :samples]

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
    store_location
    decorate_article

    if current_user.try(:status) == "active"
      mixpanel.track("Article Visit", :title => @article.subject)

      @comments = CommentDecorator.decorate(@article.comments.order("created_at"))
    else
      shared_by = User.find_by_share_token(params[:u]).hashed_id

      mixpanel.track("Shared Article Visit", :title     => @article.subject,
                                             :shared_by => shared_by)

      render "shared"
    end
  end

  def shared
    @share = SharedArticle.find_by_secret(params[:secret])

    if @share
      redirect_to ArticleLink.new(@share.article).path(@share.user.share_token)
    else
      render_http_error 404
    end
  end

  def samples
    redirect_to "/"
  end

  def random
    mixpanel.track("Random Article Visit")

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
    missing_token       = current_user && params[:u].blank?

    redirect_to(article_path(@article)) if slug_needs_updating || missing_token
  end

  def validate_token
    return if current_user.try(:active?)

    unless params[:u].present? && User.find_by_share_token_and_status(params[:u], "active")
      attempt_user_login
    end
  end

  def decorate_article
    @article = ArticleDecorator.decorate(@article)
  end

  def authenticate_admin
    raise unless current_user.admin
  end
end

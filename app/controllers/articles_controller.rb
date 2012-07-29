class ArticlesController < ApplicationController
  before_filter :find_article, :only => [:show, :edit, :update, :share]
  before_filter :create_visit, :only => [:show]

  skip_before_filter :authenticate,      :only => [:shared, :index]
  skip_before_filter :authenticate_user, :only => [:shared, :index]

  def index
    if params[:volume]
      @group = VolumeDecorator.find_by_number(params[:volume].to_i)
    elsif params[:collection]
      @group = CollectionDecorator.find_by_slug(params[:collection])
    else
      return redirect_to library_path
    end

    unless @group
      return render :text => "Article listing not found!", :status => 404
    else
      @collections = CollectionDecorator.decorate(Collection.all) #TODO Add manual order by
      @volumes     = VolumeDecorator.decorate(Volume.order("number"))
    end
  end

  def

  def show
    authenticate_admin if @article.status == "draft"

    @comments = CommentDecorator.decorate(@article.comments.order("created_at"))
  end

  def share
    @share = SharedArticle.find_or_create_by_article_id_and_user_id(
      @article.id, current_user.id)

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
      return render :text => "Article not found!", :status => 404
    else
      @share.viewed unless current_user
      @user    = UserDecorator.decorate(@share.user)
      @article = @share.article
    end
  end

  def random
    redirect_to Article.where(:status => "published").sample
  end

  private

  def find_article
    if params[:volume] && params[:issue]
      @article = Article.find_by_issue_number("#{params[:volume]}.#{params[:issue]}")
    else
      @article = Article.find(params[:id])
    end
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

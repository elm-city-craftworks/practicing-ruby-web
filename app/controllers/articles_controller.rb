class ArticlesController < ApplicationController
  before_filter :find_article, :only => [:show, :edit, :update, :share]
  before_filter :create_visit, :only => [:show]

  skip_before_filter :authenticate,      :only => [:shared]
  skip_before_filter :authenticate_user, :only => [:shared]

  def index
    if params["volume"]
      @article_groupings = Volume.where(:number => params["volume"].to_i)
    elsif params["collection"]
      @article_groupings = Collection.where(:slug => params["collection"])
    else
      redirect_to "/library" 
    end
  end

  def show
    authenticate_admin if @article.status == "draft"

    @comments = @article.comments.order("created_at")

    decorate_article
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
      @user  = @share.user
      @article = @share.article
      decorate_article
    end
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

  def decorate_article
    @article = ArticleDecorator.decorate(@article)
  end
end

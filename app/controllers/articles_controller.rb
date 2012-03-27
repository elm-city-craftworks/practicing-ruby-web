class ArticlesController < ApplicationController
  before_filter :find_article, :only => [:show, :edit, :update, :share]
  before_filter :create_visit, :only => [:show]

  skip_before_filter :authenticate,      :only => [:shared]
  skip_before_filter :authenticate_user, :only => [:shared]

  def index
    @v2_articles = Article.where("issue_number LIKE '2.%'").
                           order(:created_at)

    @v3_articles = Article.where("issue_number LIKE '3.%'").
                           order(:created_at)
  end

  def show
    authenticate_admin if @article.status == "draft"
    @comments = @article.comments.order("created_at")
  end

  def share
    @share = SharedArticle.find_or_create_by_article_id_and_user_id(
      @article.id, current_user.id)
  end

  def shared
    @share = SharedArticle.find_by_secret(params[:secret])

    unless @share
      return render :text => "Article not found!", :status => 404
    else
      @share.viewed unless current_user
      @user  = @share.user
      @article = @share.article
    end
  end

  private

  def find_article
    @article = Article.find(params[:id])
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

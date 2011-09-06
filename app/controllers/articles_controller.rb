class ArticlesController < ApplicationController
  before_filter :authenticate_admin, :only => [:create, :new, :edit, :update,
                                               :destroy]
  before_filter :find_article, :only => [:show, :edit, :update, :share]

  skip_before_filter :authenticate,      :only => [:shared]
  skip_before_filter :authenticate_user, :only => [:shared]

  def index
    @articles = Article.where(:status => "published").order(:created_at)
  end

  def show
    authenticate_admin if @article.status == "draft"
    @comments = @article.comments.order("created_at")
  end

  def update
    @article.update_attributes(params[:article])
    redirect_to article
  end

  def share
    @share = SharedArticle.find_or_create_by_article_id_and_user_id(
      @article.id, current_user.id)
  end

  def shared
    @share = SharedArticle.find_by_secret(params[:secret])

    unless @share
      raise "Invalid Share Key"
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

end

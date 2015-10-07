class ArticlesController < ApplicationController
  before_filter :find_article,      :only => [:show, :edit, :update, :share]
  before_filter :update_url,        :only => :show
  before_filter :validate_token,    :only => :show
  before_filter :authenticate,      :only => :index
  before_filter :authenticate_user, :only => :index

  def index
    @branded_footer = true
    @articles = Article.order("published_time DESC")
    unless current_user.try(:admin)
      @articles = @articles.published
    end
    @recommended = @articles.where(:recommended => true).limit(5)
    @random      = @articles.where(:recommended => false).all.sample(5).
      map(&:decorate)
    @recommended = @recommended.map(&:decorate)


    @article_count = @articles.count
    @articles      = @articles.decorate
  end

  def show
    @hide_nav       = true
    @branded_footer = true
    store_location
    decorate_article

    if current_user.try(:status) == "active"
      @comments = @article.comments.order("created_at").decorate
    end
  end

  def shared
    @share = SharedArticle.find_by_secret(params[:secret])

    if @share
      redirect_to article_path(@share.article)
    else
      render_http_error 404
    end
  end

  def samples
    redirect_to "/"
  end

  def random
    redirect_to Article.where(:status => "public").sample
  end

  private

  def find_article
    @article = Article[params[:id]]

    render_http_error(404) unless @article
  end

  # NOTE: This method uses our custom override of article_path in ApplicationHelper

  def update_url
    slug_needs_updating = @article.slug.present? && params[:id] != @article.slug

    redirect_to(article_path(@article)) if slug_needs_updating
  end

  def validate_token
    return if current_user.try(:active?)

    unless params[:u].present? && User.find_by_share_token_and_status(params[:u], "active")
      attempt_user_login unless @article.status == "public"
    end
  end

  def decorate_article
    @article = @article.decorate
  end

  def authenticate_admin
    access_denied unless current_user.admin
  end
end

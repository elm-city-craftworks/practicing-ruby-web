class ArticlesController < ApplicationController
  before_filter :authenticate_admin, :only => [:create, :new, :edit, :update, :destroy]
  before_filter :find_article, :only => [:show, :edit, :update, :share]

  def index
    @articles = Article.where(:status => "published").order(:created_at)
  end

  def show
    authenticate_admin if @article.status == "draft"

    @subject = @article.subject

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      :autolink            => true,
      :space_after_headers => true,
      :no_intra_emphasis   => true)

    @body    = markdown.render(@article.body).html_safe
  end

  def update
    @article.update_attributes(params[:article])
    redirect_to article
  end

  def share

  end

  private

  def find_article
    @article = Article.find(params[:id])
  end

  def authenticate_admin
    raise unless current_user.admin
  end

end

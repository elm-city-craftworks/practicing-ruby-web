class ArticlesController < ApplicationController
  before_filter :authenticate_admin, :except => [:index, :show]

  def index
    @articles = Article.where(:status => "published").order(:created_at)
  end

  def show
    article = Article.find(params[:id])
    authenticate_admin if article.status == "draft"

    @subject = article.subject

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      :autolink            => true, 
      :space_after_headers => true,
      :no_intra_emphasis   => true)

    @body    = markdown.render(article.body).html_safe
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    article = Article.find(params[:id])
    article.update_attributes(params[:article])
    redirect_to article
  end 

  def authenticate_admin
    raise unless current_user.admin
  end

end

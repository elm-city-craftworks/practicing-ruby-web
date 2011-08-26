class ArticlesController < ApplicationController
  before_filter :authenticate_admin, :except => [:index, :show]

  def show
    article = Article.find(params[:id])

    @subject = article.subject

    @body    = RDiscount.new(article.body).to_html.html_safe
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
    raise unless session[:seekrit] == "unicorngangsta"
  end
end

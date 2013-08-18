module Admin
  class ArticlesController < ApplicationController
    before_filter :admin_only
    before_filter :find_article, :only => [:edit, :update, :destroy]

    def index
      @articles = Article.order("created_at DESC")
    end

    def new
      @article = Article.new
    end

    def create
      @article = Article.new(params[:article])

      if @article.save
        flash[:notice] = "Article successfully created."
        redirect_to article_path(@article)
      else
        render :action => :new
      end
    end

    def edit

    end

    def update
      if @article.update_attributes(params[:article])
        expire_fragment("article_body_#{@article.id}")

        flash[:notice] = "Article successfully updated."
        redirect_to article_path(@article)
      else
        render :action => :edit
      end
    end

    def destroy
      @article.destroy

      flash[:notice] = "Article successfully destroyed."
      redirect_to admin_articles_path
    end

    private

    def find_article
      @article = Article[params[:id]]
    end
  end
end

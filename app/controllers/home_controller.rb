class HomeController < ApplicationController
  skip_before_filter :authenticate, :except => [:library]
  skip_before_filter :authenticate_user, :except => [:library]

  def contact
  end

  def subscribe
    redirect_to registration_path
  end

  def index
    if current_user
      if current_user.status == "active"
        return redirect_to back_or_default(library_path)
      elsif current_user.status != "disabled"
        return redirect_to registration_path
      end
    end

    @article_count = [Article.published.count / 10, "0+"].join

    render :index, :layout => "landing"
  end

  def library
    @article_count = Article.where(:status => "published").count
    @recent = ArticleDecorator.decorate(Article.order("published_time DESC").
                                        published.limit(5))
    @recommended = ArticleDecorator.decorate(Article.published.
      where(:recommended => true).order("published_time DESC").limit(5))
  end

  def archives
    @articles = Article.order("published_time DESC")

    unless current_user.try(:admin)
      @articles = @articles.where(:status => "published")
    end

    @articles = ArticleDecorator.decorate(@articles)
    @articles = @articles.group_by {|a| a.published_time.strftime("%B %Y") }
  end
end

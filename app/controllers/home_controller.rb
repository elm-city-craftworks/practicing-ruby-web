class HomeController < ApplicationController
  skip_before_filter :authenticate, :except => [:library]
  layout "landing", :except => [:contact, :archives, :library]

  def subscribe
    mixpanel.track("Click Subscribe Button")

    redirect_to registration_path
  end

  def index
    if current_user
      return redirect_to articles_path
    end

    mixpanel.track("Visit Landing Page")

    @article_count = [Article.published.count / 10, "0+"].join

    render :index, :layout => "landing"
  end

  def library
    @article_count = Article.where(:status => "published").count
    @recent = ArticleDecorator.decorate(Article.order("published_time DESC").
                                        published.limit(7))
    @recommended = ArticleDecorator.decorate(Article.published.
      where(:recommended => true).order("published_time DESC").limit(7))
  end

  def archives
    mixpanel.track("Visit Archives")

    @articles = Article.where(:status => "published").order("published_time DESC")
    @articles = ArticleDecorator.decorate(@articles)
    @articles = @articles.group_by {|a| a.published_time.strftime("%B %Y") }
  end
end

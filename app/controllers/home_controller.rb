class HomeController < ApplicationController
  skip_before_filter :authenticate, :except => [:library]
  skip_before_filter :authenticate_user, :except => [:library]
  layout "landing", :except => [:contact, :archives, :library]

  def contact
    mixpanel.track("Visit Contact Page")
  end

  def subscribe
    mixpanel.track("Click Subscribe Button")

    redirect_to registration_path
  end

  def index
    if current_user.try(:status) == "active"
      return redirect_to library_path
    end

    mixpanel.track("Visit Landing Page")

    @article_count = [Article.published.count / 10, "0+"].join

    render :index, :layout => "landing"
  end

  def library
    mixpanel.track("Home Visit")

    @article_count = Article.where(:status => "published").count
    @recent = ArticleDecorator.decorate(Article.order("published_time DESC").
                                        published.limit(5))
    @recommended = ArticleDecorator.decorate(Article.published.
      where(:recommended => true).order("published_time DESC").limit(5))
  end

  def archives
    mixpanel.track("Visit Archives")

    @articles = Article.order("published_time DESC")
    unless current_user.try(:admin)
      @articles = @articles.where(:status => "published")
    end
    @articles = ArticleDecorator.decorate(@articles)
    @articles = @articles.group_by {|a| a.published_time.strftime("%B %Y") }
  end
end

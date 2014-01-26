class HomeController < ApplicationController
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
      @articles = @articles.published
    end

    @articles = ArticleDecorator.decorate(@articles)
    @articles = @articles.group_by {|a| a.published_time.strftime("%B %Y") }
  end

  def public_archives
    @articles = Article.order("published_time DESC").public

    @counts = { :published => Article.published.count,
                :members   => Article.subscriber_only.count,
                :public    => @articles.count }


    @member_old_date = Article.subscriber_only
                              .order("published_time")
                              .first.published_time
                              .strftime("%B %Y")

    @member_recent_date = Article.subscriber_only
                                 .order("published_time DESC")
                                 .first.published_time
                                 .strftime("%B %Y")

    
    @articles = ArticleDecorator.decorate(@articles)
    @articles = @articles.group_by {|a| a.published_time.strftime("%B %Y") }
  end
end

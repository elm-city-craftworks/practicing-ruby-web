class HomeController < ApplicationController
  def public_archives
    redirect_to(articles_path) && return if current_user.try(:active?)

    @articles = Article.order("published_time DESC").public

    @counts = { :published => Article.published.count,
                :members   => Article.subscriber_only.count,
                :public    => @articles.count }


    @member_old_date = Article.subscriber_only
                              .order("published_time")
                              .first.try(:published_time)
                              .try(:strftime, "%B %Y")

    @member_recent_date = Article.subscriber_only
                                 .order("published_time DESC")
                                 .first.try(:published_time)
                                 .try(:strftime, "%B %Y")

    @articles = @articles.decorate.group_by do |a|
      a.published_time.strftime("%B %Y")
    end
  end
end

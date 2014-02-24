class HomeController < ApplicationController
  before_filter :attempt_user_login, :only => 'chat'
  def public_archives
    redirect_to(articles_path) && return if current_user.try(:active?)

    @branded_footer = true
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

    @articles = @articles.decorate
  end

  def toggle_nav
    session[:nav_hidden] = !session[:nav_hidden]

    render :text => "OK"
  end

  def chat
    render :layout => false
  end
end

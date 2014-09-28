class HomeController < ApplicationController
  before_filter :attempt_user_login, :only => 'chat'
  def public_archives
    redirect_to(articles_path) && return if current_user.try(:active?)

    @branded_footer = true
    @articles = Article.order("published_time DESC").public

    @articles = @articles.decorate
  end

  def about
    @articles = Article.order("published_time DESC").public


    @counts = { :published => Article.published.count,
                :members   => Article.subscriber_only.count,
                :public    => @articles.count }
  end

  def toggle_nav
    session[:nav_hidden] = !session[:nav_hidden]

    render :text => "OK"
  end

  def chat
    render :layout => false
  end
end

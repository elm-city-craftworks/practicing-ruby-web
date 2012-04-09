class HomeController < ApplicationController
  skip_before_filter :authenticate, :only => [:index]
  skip_before_filter :authenticate_user, :only => [:index]

  def index
    if current_user
      return redirect_to articles_path
    end

    @recent_topics = Article.published.order("published_time DESC").limit(5)

    render :index, :layout => "landing"
  end
end

class HomeController < ApplicationController
  skip_before_filter :authenticate
  skip_before_filter :authenticate_user

  layout "landing"

  def index
    if current_user
      redirect_to articles_path
    end

    @recent_topics = Article.order("created_at DESC").limit(5)
  end

end

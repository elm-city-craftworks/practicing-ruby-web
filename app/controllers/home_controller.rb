class HomeController < ApplicationController
  skip_before_filter :authenticate,      :only => [:index]
  skip_before_filter :authenticate_user, :only => [:index]

  def index
    if current_user
      return redirect_to articles_path
    end

    @article_count = [Article.published.count / 10, "0+"].join

    render :index, :layout => "landing"
  end
end

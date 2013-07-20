class HomeController < ApplicationController
  skip_before_filter :authenticate, :except => [:library]
  layout "landing", :except => [:library, :contact]

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
    @collections   = CollectionDecorator.decorate(Collection.order("position"))
    @volumes       = VolumeDecorator.decorate(Volume.order("number"))
  end
end

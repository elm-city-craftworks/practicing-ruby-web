class HomeController < ApplicationController
  skip_before_filter :authenticate, :only => "index"

  def index
    if current_user
      return redirect_to articles_path
    end

    @article_count = [Article.published.count / 10, "0+"].join

    @ivory_towers = CollectionDecorator.find_by_name("Ivory Towers")
    @ruby         = CollectionDecorator.find_by_name("Our Beloved Ruby")
    @strategery   = CollectionDecorator.find_by_name("Strategery")
    @nuts_bolts   = CollectionDecorator.find_by_name("Nuts and Bolts")

    render :index, :layout => "landing"
  end

  def library
    @article_count = Article.where(:status => "published").count
    @collections   = CollectionDecorator.decorate(Collection.order("position"))
    @volumes       = VolumeDecorator.decorate(Volume.order("number"))
  end
end

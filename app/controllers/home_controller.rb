class HomeController < ApplicationController
  skip_before_filter :authenticate
  skip_before_filter :authenticate_user

  def index
    if current_user
      return redirect_to articles_path
    end

    @article_count = [Article.published.count / 10, "0+"].join

    render :index, :layout => "landing"
  end

  def library
    @article_count = Article.where(:status => "published").count
    @collections   = CollectionDecorator.decorate(Collection.all) #TODO Add manual order by
    @volumes       = VolumeDecorator.decorate(Volume.order("number"))
  end
end

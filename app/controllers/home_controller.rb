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

  def new_subscription
    url = "http://practicingruby.us2.list-manage.com/subscribe?u=8980fe01915375e99364fcdd0&id=281315c053"
    url += "&MERGE0=#{params[:email]}" if params[:email]

    # TODO: Add fancy logging here

    respond_to do |format|
      format.html { redirect_to url }
      format.js   { render :text => "// OK #{params[:email]}" }
    end
  end

  def library
    @article_count = Article.where(:status => "published").count
    @collections   = CollectionDecorator.decorate(Collection.order("position"))
    @volumes       = VolumeDecorator.decorate(Volume.order("number"))
  end
end

class CommunityController < ApplicationController
  def show
    redirect_to articles_path
  end
end

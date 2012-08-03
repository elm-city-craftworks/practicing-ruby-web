class AnnouncementsController < ApplicationController
  def index
    redirect_to "http://elmcitycraftworks.org/"
  end

  def show
    redirect_to "http://elmcitycraftworks.org/"
  end

  def dismiss
    ids = active_broadcasts.map(&:id)
    session[:dismissed_broadcasts] += ids
  end
end

class AnnouncementsController < ApplicationController

  def index
    @announcements = Announcement.order("created_at DESC").all
  end

  def show
    @announcement = Announcement.find(params[:id])
  end
end

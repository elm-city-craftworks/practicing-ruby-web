module Admin
  class BroadcastsController < ApplicationController
    before_filter :admin_only

    def new

    end

    def create
      if params[:subject].blank? || params[:body].blank?
        flash[:error] = "Subject and body are required"
        render(:new) && return
      end

      if params[:commit] == "Test"
        Broadcaster.notify_testers(params)
      else
        Broadcaster.notify_subscribers(params)
      end

      flash[:notice] = "Message sent"
      redirect_to :action => :new

    end
  end
end

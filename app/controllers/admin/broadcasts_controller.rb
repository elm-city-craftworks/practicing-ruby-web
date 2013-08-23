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

      message = { :subject => params[:subject],
                  :body    => params[:body] }

      if params[:commit] == "Test"
        message[:to] = params[:to]

        Broadcaster.notify_testers(message)
      else
        Broadcaster.delay.notify_subscribers(message)
      end

      flash[:notice] = "Message sent"
      redirect_to :action => :new

    end
  end
end

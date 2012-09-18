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

      BroadcastMailer.deliver_broadcast(params)
      flash[:notice] = "Message sent"
      redirect_to :action => :new

    end
  end
end
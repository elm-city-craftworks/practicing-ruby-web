class HooksController < ApplicationController
  skip_before_filter :authenticate
  skip_before_filter :authenticate_user

  def receive
    webhooks = MailChimp::WebHooks.new(params)

    render :text => webhooks.process
  end

end

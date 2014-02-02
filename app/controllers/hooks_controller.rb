class HooksController < ApplicationController
  def receive
    webhooks = MailChimp::WebHooks.new(params)

    render :text => webhooks.process
  end
end

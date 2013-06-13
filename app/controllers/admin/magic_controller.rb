class Admin::MagicController < ApplicationController
  before_filter :admin_only

  def freebie
    user = User.where(:github_nickname => params["nickname"]).first

    raise if user.subscriptions.active

    user.status = "active"
    user.save
    
    user.subscriptions.create(:payment_provider   => "free",
                              :monthly_rate_cents => 0,
                              :start_date         => Date.today)

    render :text => "ok"
  end
end

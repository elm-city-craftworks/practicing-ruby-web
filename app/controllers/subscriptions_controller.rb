class SubscriptionsController < ApplicationController
  before_filter :authenticate,      :except => [:redirect, :index]
  before_filter :ye_shall_not_pass, :except => [:redirect, :index]

  def index
    if %w[authorized pending_confirmation confirmed
      payment_pending].include? current_user.try(:status)
      redirect_to(:action => :new) && return
    end

    @article_count = [Article.published.count / 10, "0+"].join
  end

  def redirect
    render :layout => false
  end

  def create
    payment_gateway = current_user.payment_gateway
    begin
      payment_gateway.subscribe(params)
      redirect_to root_path(:new_subscription => true)
    rescue Stripe::CardError => e
      @errors = e.message
      render :action => :new
    end
  end

  def coupon_valid
    payment_gateway = current_user.payment_gateway

    valid = payment_gateway.coupon_valid?(params[:coupon])

    render :json => { :coupon_valid => valid }.to_json
  end

  private

  def ye_shall_not_pass
    if current_user && current_user.status == "active"
      redirect_to root_path, :notice => "Your account is already setup."
    end
  end
end

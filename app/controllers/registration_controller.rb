class RegistrationController < ApplicationController
  skip_before_filter :authenticate_user
  before_filter :ye_shall_not_pass, :except => [ :complete ]

  def index
    path = case current_user.status
      when "authorized", "pending_confirmation", "confirmed", "payment_pending"
        {:action => :payment }
      else
        library_path
    end

    redirect_to path
  end

  def restart
    current_user.status = "authorized"
    current_user.save

    redirect_to :action => :payment
  end

  def payment
    if current_user.status == "active"
      redirect_to(:action => :complete)
    end
  end

  # FIXME: THIS CODE IS NOT FULLY UNDER TEST!
  # there are unit tests for PaymentGateway#subscribe(),
  # but no acceptance tests walk this path. Tread lightly!
  def create_payment
    payment_gateway = current_user.payment_gateway
    begin
      payment_gateway.subscribe(params)

      redirect_to :action => :complete
    rescue Stripe::CardError => e
      @errors = e.message
      render :action => :payment
    end
  end

  def coupon_valid
    payment_gateway = current_user.payment_gateway

    valid = payment_gateway.coupon_valid?(params[:coupon])

    render :json => { :coupon_valid => valid }.to_json
  end

  private

  # Called by ApplicationController#authenticate
  def redirect_on_auth_failure
    redirect_to login_path
  end

  def ye_shall_not_pass
    if current_user && current_user.status == "active"
      redirect_to root_path, :notice => "Your account is already setup."
    end
  end
end

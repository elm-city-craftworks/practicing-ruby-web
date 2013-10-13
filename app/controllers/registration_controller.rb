class RegistrationController < ApplicationController
  skip_before_filter :authenticate_user
  before_filter :ye_shall_not_pass, :except => [ :payment, :payment_pending,
                                                 :create_payment, :complete ]

  def index
    path = case current_user.status
      when "authorized"           then {:action => :edit_profile }
      when "pending_confirmation" then {:action => :update_profile }
      when "confirmed"            then {:action => :payment }
      when "payment_pending"      then {:action => :payment }
      else library_path
    end

    redirect_to path
  end

  def restart
    current_user.status = "authorized"
    current_user.save

    redirect_to :action => :edit_profile
  end

  def edit_profile
    mixpanel.track("Contact info requested")

    @user = current_user
  end

  def update_profile
    @user = current_user

    if params[:user]
      if @user.update_attributes(params[:user])
        @user.create_access_token

        RegistrationMailer.email_confirmation(@user).deliver

        mixpanel.track("Confirmation email sent")

        @user.update_attribute(:status, "pending_confirmation")
      else
        render :edit_profile
      end
    end
  end

  def confirm_email
    user = User.find_by_access_token(params[:secret])

    return redirect_to(:action => :index) unless user

    user.clear_access_token
    user.update_attribute(:status, "confirmed")

    return redirect_to(:action => :payment)
  end

  def payment_pending

  end

  def payment
    mixpanel.track("Payment requested")

    unless current_user.status == "payment_pending" || current_user.status == "confirmed"
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
      mixpanel.track("Payment complete")

      redirect_to :action => :complete
    rescue Stripe::CardError => e
      @errors = e.message
      render :action => :payment
    end
  end

  def complete
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

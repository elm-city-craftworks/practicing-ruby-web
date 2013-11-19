class UsersController < ApplicationController
  before_filter      :find_user,         :except => :show
  skip_before_filter :authenticate_user, :only   => :destroy

  def show
    @user = User.find_by_github_nickname(params[:id])

    raise ActionController::RoutingError.new('Not Found') unless @user

    @user = UserDecorator.decorate(@user)

    redirect_to @user.github_url
  end

  def billing
    @subscriptions = SubscriptionDecorator.decorate(
      @user.subscriptions.order("start_date"))
    @active_subscription = @user.subscriptions.active.try(:decorate)
    @credit_card   = current_user.credit_card
  end

  def update_credit_card
    begin
      payment_gateway = current_user.payment_gateway
      payment_gateway.update_credit_card(params)

      flash[:notice] = "Your credit card was sucessfully updated!"
      redirect_to billing_settings_path
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to billing_settings_path
    end
  end

  def update
    params[:current_page] ||= :edit

    if @user.update_attributes(cleaned_params)
      flash[:notice] = "#{params[:current_page].humanize} settings updated!"
      redirect_to :action => params[:current_page]
    else
      render :action => params[:current_page]
    end
  end

  def change_billing_interval
    new_interval = params[:interval]
    payment_gateway = current_user.payment_gateway
    payment_gateway.change_interval(new_interval)

    flash[:notice] = "You have sucessfully changed to #{new_interval}ly billing"
    redirect_to billing_settings_path
  end

  def destroy
    AccountMailer.canceled(@user) unless @user.disabled?
  end

  private

  def find_user
    @user = current_user
  end

  def cleaned_params
    approved_params = %w{notify_conversations notify_mentions notify_comment_made
      beta_tester contact_email notify_updates}

    params[:user].select {|k,_| approved_params.include? k }
  end
end

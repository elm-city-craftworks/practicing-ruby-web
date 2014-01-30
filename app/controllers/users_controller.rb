class UsersController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_user, :except => [:destroy, :email_unique]
  before_filter :find_user,         :except => :show

  def show
    @user = User.find_by_github_nickname(params[:id])

    raise ActionController::RoutingError.new('Not Found') unless @user

    @user = @user.decorate

    redirect_to @user.github_url
  end

  def billing
    @subscriptions       = @user.subscriptions.order("start_date").decorate
    @active_subscription = @user.subscriptions.active.try(:decorate)
    @credit_card         = current_user.credit_card
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
    if @user.update_attributes(cleaned_params)
      session.delete(:dismiss_email_warning)
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

  def mailchimp_yearly_billing
    AccountMailer.mailchimp_yearly_billing(@user)
  end

  def destroy
    AccountMailer.canceled(@user) unless @user.disabled?
  end

  def email_unique
    email = params[:email] || (params[:user] && params[:user][:contact_email])
    unique = User.where("id <> ? and contact_email = ?",
                        @user, email.downcase).empty?

    message = if unique
      true
    else
      { error: "This email is already registered" }
    end

    render :text => message.to_json
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

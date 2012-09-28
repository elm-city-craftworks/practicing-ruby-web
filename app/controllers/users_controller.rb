class UsersController < ApplicationController
  before_filter      :find_user,         :except => :show
  skip_before_filter :authenticate_user, :only   => :destroy

  def show
    @user = User.find_by_github_nickname(params[:id])

    raise ActionController::RoutingError.new('Not Found') unless @user

    @user = UserDecorator.decorate(@user)

    redirect_to @user.github_url
  end

  def edit

  end

  def update
    if @user.update_attributes(cleaned_params)
      flash[:notice] = "Settings sucessfully updated!"
      redirect_to edit_user_path(@user)
    else
      render :action => :edit
    end
  end

  def destroy
    # TODO Send unsubscribe email
    # TODO Update payment provider

    @user.disable

    delete_mailchimp_account
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

  def delete_mailchimp_account
    return if @user.mailchimp_web_id.blank?
    UserManager.delay.delete_user!(@user.email)
  end
end

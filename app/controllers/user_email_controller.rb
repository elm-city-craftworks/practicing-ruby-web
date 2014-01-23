class UserEmailController < ApplicationController
  def confirm
    user = User.find_by_access_token(params[:secret])

    if user
      user.clear_access_token
      user.update_attributes(:email_confirmed => true)
      flash[:notice] = "Email address confirmed"
    else
      flash[:error] = "Sorry that confirmation link is out of date."
    end

    redirect_to user_settings_path
  end

  def change
    @user = current_user

    render :layout => false
  end

  def dismiss_warning
    session[:dismiss_email_warning] = true
  end
end

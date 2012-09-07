class RegistrationController < ApplicationController
  # before_filter :ye_shall_not_pass, :except => [:payment]

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user

    if params[:user]
      @user.update_attributes(params[:user])

      @user.create_access_token

      @user.update_attribute(:status, "pending_confirmation")

      RegistrationMailer.email_confirmation(@user).deliver
    end
  end

  def confirm_email
    user = User.find_by_access_token(params[:secret])

    if user || current_user.try(:status) == "confirmed"
      user.clear_access_token

      # TODO swtich this to confirmed one we are doing payment processing
      user.update_attribute(:status, "active")

      return redirect_to(:action => :payment)
    end
  end

  def payment
    # TODO fancy payment stuffs
  end

  private

  def ye_shall_not_pass
    if current_user && current_user.status == "active"
      redirect_to root_path, :notice => "Your account is already setup."
    end
  end
end
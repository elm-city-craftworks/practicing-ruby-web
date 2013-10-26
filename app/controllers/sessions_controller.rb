class SessionsController < ApplicationController
  skip_before_filter :authenticate
  skip_before_filter :authenticate_user

  def new
    provider = Rails.env.development? ? "developer" : "github"
    redirect_to("/auth/#{provider}")
  end

  def create
    auth = request.env['omniauth.auth']
    github_uid = auth["uid"].to_s

    authorization = Authorization.find_or_create_by_github_uid(github_uid)

    session["authorization_id"] = authorization.id

    if authorization.user.blank?
      user = User.create(:contact_email => auth["info"]["email"],
        :github_nickname => auth["info"]["nickname"])

      user.update_attribute(:status, "authorized")
      authorization.update_attribute(:user_id, user.id)

      redirect_to registration_edit_profile_path
    elsif authorization.user.status == "active"
      redirect_back_or_default(library_path)
    else
      redirect_to registration_path
    end
  end

  def destroy
    session.delete("authorization_id")
    clear_location
    redirect_to "/"
  end
  
  def failure
    @message = params[:message].humanize if params[:message]
    mixpanel.track("Github failure")
  end

end

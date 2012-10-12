class SessionsController < ApplicationController
  skip_before_filter :authenticate
  skip_before_filter :authenticate_user

  def new
    redirect_to '/auth/github'
  end

  def create
    auth = request.env['omniauth.auth']
    github_uid = auth["uid"].to_s

    authorization = Authorization.find_or_create_by_github_uid(github_uid)

    session["authorization_id"] = authorization.id

    unless authorization.user
      user = User.create(:contact_email => auth["info"]["email"],
        :github_nickname => auth["info"]["nickname"])

      user.update_attribute(:status, "authorized")
      authorization.update_attribute(:user_id, user.id)

      redirect_to registration_edit_profile_path
    else
      redirect_back_or_default(library_path)
    end
  end

  def destroy
    session.delete("authorization_id")
    redirect_to "/"
  end

end

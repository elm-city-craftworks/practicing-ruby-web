class SessionsController < ApplicationController
  def new
    case ENV["AUTH_MODE"]
    when "developer"
      redirect_to "/auth/developer"
    when "github"
      redirect_to "/auth/github"
    else
      raise "Programmer Error: Invalid auth mode!"
    end
  end

  def create
    auth = request.env['omniauth.auth']
    github_uid = auth["uid"].to_s

    authorization = Authorization.find_or_create_by_github_uid(github_uid)

    session["authorization_id"] = authorization.id

    if authorization.user.blank?
      user = User.new(:contact_email => auth["info"]["email"],
        :github_nickname => auth["info"]["nickname"])
      user.status = "authorized"
      user.save

      authorization.update_attributes(:user_id => user.id)

      redirect_to new_subscription_path
    elsif authorization.user.status == "active"
      redirect_back_or_default(articles_path)
    else
      redirect_to new_subscription_path
    end
  end

  def destroy
    session.delete("authorization_id")
    clear_location
    redirect_to "/"
  end

  def failure
    @message = params[:message].humanize if params[:message]
  end

end

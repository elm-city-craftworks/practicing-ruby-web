class SessionsController < ApplicationController
  skip_before_filter :authenticate
  skip_before_filter :authenticate_user

  def subscribe
    url = "http://practicingruby.us2.list-manage.com/subscribe?u=8980fe01915375e99364fcdd0&id=281315c053"
    url += "&MERGE0=#{params[:email]}" if params[:email]

    # TODO: Add fancy logging here

    respond_to do |format|
      format.html { redirect_to url }
      format.js   { render :text => "// OK #{params[:email]}" }
    end
  end

  def create
    auth = request.env['omniauth.auth']
    github_uid = auth["uid"].to_s

    if authorization = Authorization.find_by_github_uid(github_uid)
      login_or_finish_confirmation(authorization)
    else
      authorization = Authorization.create(:github_uid => github_uid)

      start_confirmation(authorization, auth["info"])
    end
  end

  def link
    if AuthorizationLink.activate(params[:secret])
      redirect_to library_path
    else
      render("expired_link")
    end
  end

  def destroy
    session.delete("authorization_id")
    redirect_to "/"
  end

  private

  def login_or_finish_confirmation(authorization)
    session["authorization_id"] = authorization.id

    if authorization.confirmed?
      current_user.update_attribute(:notifications_enabled, true)

      redirect_back_or_default(library_path)
    elsif link = authorization.authorization_link
      redirect_to authorization_link_path(link)
    else
      raise "Orphaned"
    end
  end

  def start_confirmation(authorization, user_info)
    session["authorization_id"] = authorization.id
    github_email                = user_info["email"].to_s.downcase

    link = AuthorizationLink.create(:authorization_id => authorization.id,
                                    :github_nickname  => user_info["nickname"])

    if User.find_by_email(github_email)
      link.update_attribute(:mailchimp_email, github_email)

      AuthorizationLinksMailer.email_confirmation(link).deliver
      redirect_to link
    else
      redirect_to edit_authorization_link_path(link)
    end
  end
end

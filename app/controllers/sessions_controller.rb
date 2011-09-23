class SessionsController < ApplicationController
  skip_before_filter :authenticate
  skip_before_filter :authenticate_user

  def create
    auth = request.env['omniauth.auth']
    github_uid = auth["uid"].to_s

    if authorization = Authorization.find_by_github_uid(github_uid)
      session["authorization_id"] = authorization.id

      if authorization.user
        redirect_back_or_default(community_url)
      elsif link = authorization.authorization_link
        redirect_to authorization_link_path(link)
      else
        raise "Orphaned"
      end
    else
      authorization = Authorization.create(:github_uid => github_uid)
      session["authorization_id"] = authorization.id

      link = AuthorizationLink.new(:authorization_id => authorization.id,
                                   :github_nickname  => auth["user_info"]["nickname"])

      if User.find_by_email(auth["user_info"]["email"])
        link.mailchimp_email = auth["user_info"]["email"]
      end

      link.save

      if link.mailchimp_email
         AuthorizationLinksMailer.email_confirmation(link).deliver
        redirect_to link
      else
        redirect_to edit_authorization_link_path(link)
      end
    end
  end

  def link
    AuthorizationLink.activate(params[:secret])
    redirect_to community_url
  end

  def destroy
    session.delete("authorization_id")
    redirect_to "/"
  end
end

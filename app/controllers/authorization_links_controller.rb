class AuthorizationLinksController < ApplicationController
  before_filter :find_authorization_link
  before_filter :check_link_permissions

  skip_before_filter :authenticate_user

  def show
    unless @authorization_link.mailchimp_email
      redirect_to edit_authorization_link_path(@authorization_link)
    end
  end

  def create
    raise
  end

  def update
    @email = params["authorization_link"]["mailchimp_email"]

    unless User.find_by_email(@email)
      render("invalid_email") and return
    end
    
    @authorization_link.update_attributes(params["authorization_link"])

    AuthorizationLinksMailer.deliver_email_confirmation(@authorization_link)

    redirect_to @authorization_link
  end

  def find_authorization_link
    @authorization_link = AuthorizationLink.find(params["id"])
  end

  def check_link_permissions
    raise unless current_authorization == @authorization_link.authorization
  end
end

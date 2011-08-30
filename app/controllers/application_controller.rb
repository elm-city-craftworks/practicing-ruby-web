class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  before_filter :authenticate_user

  helper_method :current_user

  def authenticate
    current_authorization || redirect_to("/auth/github")
  end

  def authenticate_user
    unless current_user
      redirect_to current_authorization.authorization_link
    end
  end

  def current_authorization
    @current_authorization ||=
      Authorization.find_by_id(session[:authorization_id])
  end

  def current_user
    current_authorization.user
  end
end

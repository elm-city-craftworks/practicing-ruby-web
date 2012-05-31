class ApplicationController < ActionController::Base
  include CacheCooker::Oven

  protect_from_forgery
  before_filter :authenticate_cache_cooker!
  before_filter :authenticate
  before_filter :authenticate_user
  before_filter :enable_notifications

  helper_method :current_user

  def authenticate
    store_location
    current_authorization || redirect_to("/auth/github")
  end

  def authenticate_user
    unless current_user
      return redirect_to(current_authorization.authorization_link)
    end

    redirect_to problems_sessions_path if current_user.account_disabled
  end

  def authenticate_cache_cooker!
    if authenticate_cache_cooker
      session[:authorization_id] = Authorization.includes(:user).
        where('users.admin is TRUE').first.id
    end
  end

  def current_authorization
    @current_authorization ||= Authorization.find_by_id(session[:authorization_id])
  end

  def current_user
    current_authorization.try(:user)
  end

  def admin_only
    raise "Access Denied" unless current_user && current_user.admin
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  private

  def enable_notifications
    if current_user && !current_user.notifications_enabled
      current_user.update_attribute(:notifications_enabled, true)
    end
  end
end

class ApplicationController < ActionController::Base
  include ArticleHelper

  protect_from_forgery

  helper_method :current_user, :active_broadcasts

  private

  def authenticate
    return if current_authorization

    store_location
    redirect_on_auth_failure
  end

  def redirect_on_auth_failure
    flash[:notice] = "That page is protected. Please log in or subscribe to continue"
    redirect_to(root_path)
  end

  def authenticate_user
    return unless current_user

    if current_user.disabled?
      redirect_to problems_sessions_path
    elsif !current_user.active?
      redirect_to new_subscription_path
    end
  end

  def attempt_user_login
    authenticate
    authenticate_user
  end

  def current_authorization
    @current_authorization ||= Authorization.find_by_id(session[:authorization_id])
  end

  def current_user
    current_authorization.try(:user)
  end

  def admin_only
    unless current_user && current_user.admin
      store_location
      flash[:error] = "Sorry chief you don't have access to this area"
      redirect_to root_path
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_location
    session.delete(:return_to)
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    clear_location
  end

  def active_broadcasts
    if current_user
      session[:dismissed_broadcasts] ||= [-1]
      Announcement.broadcasts.where("id NOT IN (?)", session[:dismissed_broadcasts])
    else
      []
    end
  end

  def render_http_error(status)
    render :file   => "public/#{status}", :layout  => false,
           :status => status,             :formats => [:html]
  end
end

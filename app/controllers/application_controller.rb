class ApplicationController < ActionController::Base
  include CacheCooker::Oven
  include ApplicationHelper

  protect_from_forgery

  before_filter :authenticate_cache_cooker!
  before_filter :authenticate
  before_filter :authenticate_user
  before_filter :enable_notifications

  helper_method :current_user, :active_broadcasts

  private

  def authenticate
    return if current_authorization 
   
    store_location
    redirect_on_auth_failure
  end

  def redirect_on_auth_failure
    flash[:notice] = "That page is protected. Please sign in or sign up to continue"
    redirect_to(root_path)
  end

  def authenticate_user
    return unless current_user

    if current_user.disabled?
      redirect_to problems_sessions_path
    elsif !current_user.active?
      redirect_to registration_path
    end
  end

  def attempt_user_login
    authenticate
    authenticate_user
  end

  def authenticate_cache_cooker!
    if authenticate_cache_cooker
      @current_authorization = Authorization.includes(:user).
        where('users.admin is TRUE').first
      session[:authorization_id] = @current_authorization.try(:id)
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

  def clear_location
    session[:return_to] = nil
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

  def enable_notifications
    current_user.try(:enable_notifications)
  end

  def render_http_error(status)
    render :file   => "public/#{status}", :layout  => false,
           :status => status,             :formats => [:html]
  end

  def mixpanel
    return NullObject if cache_cooker?

    @mixpanel ||= Tracker.new(current_user, :env => request.env)
  end
end

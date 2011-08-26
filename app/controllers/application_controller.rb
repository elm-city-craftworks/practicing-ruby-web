class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  def authenticate
    authenticate_or_request_with_http_basic(
       "A real auth system is coming soon. "+
       "For now, use the email address you're using with "+
       "MailChimp as your username. Password can be left blank.") do |id, password|
      session[:seekrit] = password
      User.where(:email => id).first
    end
  end
end

class HooksController < ApplicationController
  skip_before_filter :authenticate
  skip_before_filter :authenticate_user

  def receive
    case params[:type]
    when "subscribe"
      User.create(:first_name       => params[:data][:merges][:FNAME],
                  :last_name        => params[:data][:merges][:LNAME],
                  :email            => params[:data][:email],
                  :mailchimp_web_id => params[:data][:web_id])
      render :text => "subscribed"
    when "unsubscribe"
      render :text => "ok (unsubscribe)"
#      user = find_user

#      user.try(:destroy)
#      render :text => "unsubscribed"
    when "profile"
      user = find_user

      user.update_attributes(:first_name => params[:data][:merges][:FNAME],
                             :last_name  => params[:data][:merges][:LNAME],
                             :email      => params[:data][:email])
      render :text => "update profile"
    else
      # ghetto
      if Rails.env == "development"
        raise
      else
        render :text => "ok (unsupported)"
      end
    end
  end

  private
  
  def find_user
    User.find_by_mailchimp_web_id(params[:data][:web_id])
  end
end

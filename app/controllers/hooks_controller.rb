class HooksController < ApplicationController
  def receive
    case params[:type]
    when "subscribe"
      User.create(:first_name       => params[:data][:merges][:FNAME],
                  :last_name        => params[:data][:merges][:LNAME],
                  :email            => params[:data][:email],
                  :mailchimp_web_id => params[:data][:web_id])
      render :text => "ok"
    else
      # ghetto
      if RAILS_ENV == "development"
        raise
      else
        render :text => "ok (unsupported)"
      end
    end
  end
end

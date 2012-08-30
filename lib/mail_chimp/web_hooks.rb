module MailChimp
  class WebHooks

    attr_reader :params

    def initialize(params)
      @params       = params
      @user_manager = UserManager.new
    end

    def process
      case request_type
      when "subscribe"
        subscribe
      when "unsubscribe"
        unsubscribe
      when "profile"
        profile
      else
        params[:type] = "unsupported"
      end

      "ok (#{request_type})"
    end

    def request_type
      params[:type]
    end

    def subscribe
      if user = find_user
        user.enable(params[:data][:web_id])
      else
        User.create(:first_name       => params[:data][:merges][:FNAME],
                    :last_name        => params[:data][:merges][:LNAME],
                    :email            => params[:data][:email],
                    :mailchimp_web_id => params[:data][:web_id])
      end
    end

    def unsubscribe
      find_user.try(:disable)

      unless params[:data][:action] == "delete"
        @user_manager.delete_user(params[:data][:email])
      end
    end

    def profile
      user = find_user

      user.update_attributes(:first_name => params[:data][:merges][:FNAME],
                             :last_name  => params[:data][:merges][:LNAME],
                             :email      => params[:data][:email])
    end

    def find_user
      User.find_by_mailchimp_web_id(params[:data][:web_id]) ||
      User.where("LOWER(email) = ?", params[:data][:email].downcase).first
    end
  end
end

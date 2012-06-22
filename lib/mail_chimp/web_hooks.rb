module MailChimp
  class WebHooks

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def process
      case request_type
      when "subscribe"
        subscribe
      when "unsubscribe"
        if params[:data][:action] == "delete"
          delete
        else
          unsubscribe
        end
      when "profile"
        profile
      else
        "ok (unsupported)"
      end
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

      "subscribed"
    end

    def delete
      find_user.disable

      "ok (delete unsubscribed user)"
    end

    def unsubscribe
      find_user.disable

      client = Hominid::API.new(MailChimp::SETTINGS[:api_key])
      client.list_unsubscribe(MailChimp::SETTINGS[:list_id],
                              params[:data][:email], true)

      "ok (unsubscribe)"
    end

    def profile
      user = find_user

      user.update_attributes(:first_name => params[:data][:merges][:FNAME],
                             :last_name  => params[:data][:merges][:LNAME],
                             :email      => params[:data][:email])

      "update profile"
    end

    private

    def find_user
      User.find_by_mailchimp_web_id(params[:data][:web_id]) ||
      User.find_by_email(params[:data][:email])
    end
  end
end
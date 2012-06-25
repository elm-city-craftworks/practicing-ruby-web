module MailChimp
  class Api
    attr_reader :client, :list_id

    def initialize
      @client  = Hominid::API.new(MailChimp::SETTINGS[:api_key])
      @list_id = MailChimp::SETTINGS[:list_id]
    end

    def delete_user(email)
      @client.list_unsubscribe(@list_id, email, true)
    end

    def unsubscribed_users
      @client.list_members(@list_id, "unsubscribed")["data"]
    end
  end
end
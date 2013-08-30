class UserManager
  attr_reader :client, :list_id

  def initialize
    @client  = Mailchimp::API.new(MailChimp::SETTINGS[:api_key])
    @list_id = MailChimp::SETTINGS[:list_id]
  end

  def delete_user(email)
    client.list_unsubscribe(:id            => list_id, 
                            :email_address => email, 
                            :delete_member => true)

    AccountMailer.unsubscribed(email)
  end

  def unsubscribed_users
    client.list_members(:id => list_id, :status => "unsubscribed")["data"].map {|u| u["email"] }
  end

  def disable_unsubscribed_users
    unsubscribed_users.each do |email|
      user_record = User.where(:email => email).first

      if user_record
        user_record.disable
      else
        puts "No record for #{email}"
      end

      delete_user(email)
    end
  end
end

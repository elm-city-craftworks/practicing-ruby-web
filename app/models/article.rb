class Article < ActiveRecord::Base
  before_create do
    self.mailchimp_campaign_id = create_mailchimp_campaign
  end

  before_update do
    update_mailchimp_campaign if status == "draft"
  end

  def create_mailchimp_campaign
    client = Hominid::API.new(MailChimp::SETTINGS[:api_key])
    p [subject, body]


    client.campaign_create('plaintext', 
      { :list_id    =>  MailChimp::SETTINGS[:list_id],
        :subject    => subject,
        :from_email => MailChimp::SETTINGS[:sender_email],
        :from_name  => MailChimp::SETTINGS[:sender_name] },
      { :text => body }
    )
  end

  def update_mailchimp_campaign
    client = mailchimp_client

    client.campaign_update(mailchimp_campaign_id, :subject, subject)  
    client.campaign_update(mailchimp_campaign_id, :title, subject)  
    client.campaign_update(mailchimp_campaign_id, :content, { :text => body })  
  end

  def deliver_test
    mailchimp_client.campaign_send_test(mailchimp_campaign_id, 
                                        MailChimp::SETTINGS[:testers])
  end 

  def deliver
    update_attribute("status", "in_transit")
    mailchimp_client.campaign_send_now(mailchimp_campaign_id)
  end

  private

  def mailchimp_client
    Hominid::API.new(MailChimp::SETTINGS[:api_key])
  end
end

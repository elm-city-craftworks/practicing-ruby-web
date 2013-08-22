class BroadcastMailer < ActionMailer::Base
  def self.recipients
    User.where(:notify_updates => true).to_notify.map(&:contact_email)
  end

  def broadcast(message, email)
    @body = message[:body]

    mail(:to      => email,
         :subject => message[:subject])
  end
end

class BroadcastMailer < ActionMailer::Base
  def self.recipients
    User.where(:notify_updates => true).to_notify.map(&:contact_email)
  end

  def broadcast(message, email)
    article_finder = ->(e) { article_url(Article[e]) }

    @body = Mustache.render(message[:body], :article => article_finder)
    
    mail(:to      => email,
         :subject => message[:subject])
  end
end

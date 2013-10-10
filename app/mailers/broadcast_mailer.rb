class BroadcastMailer < ActionMailer::Base
  default :from => "Gregory from Practicing Ruby <gregory@practicingruby.com>"

  def self.recipients
    User.where(:notify_updates => true).to_notify
  end

  def broadcast(message, subscriber)
    article_finder = ->(e) { ArticleLink.new(Article[e]).url(subscriber.share_token) }

    @body = Mustache.render(message[:body], :article => article_finder)
    mail(:to      => subscriber.contact_email,
         :subject => message[:subject])
  end
end

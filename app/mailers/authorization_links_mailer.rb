class AuthorizationLinksMailer < ActionMailer::Base
  def email_confirmation(link)
    @link = link
    mail(:to => @link.mailchimp_email,
         :subject => "Link your Practicing Ruby subscription to your Github Account")
  end
end

class RegistrationMailer < ActionMailer::Base
  def email_confirmation(user)
    @user = user
    mail(:to => @user.contact_email,
         :subject => "Confirm your Practicing Ruby subscription")
  end
end

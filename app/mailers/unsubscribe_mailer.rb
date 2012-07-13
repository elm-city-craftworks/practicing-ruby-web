class UnsubscribeMailer < ActionMailer::Base
  def unsubscribed(address)
    mail(:to      => address,
         :subject => "Sorry to see you go").deliver
  end
end

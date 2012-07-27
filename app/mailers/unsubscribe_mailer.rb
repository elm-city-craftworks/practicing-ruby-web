class UnsubscribeMailer < ActionMailer::Base
  def unsubscribed(address)
    @address = address

    mail(:to      => address,
         :subject => "Sorry to see you go").deliver
  end
end

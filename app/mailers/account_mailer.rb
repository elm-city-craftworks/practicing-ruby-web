class AccountMailer < ActionMailer::Base
  def unsubscribed(address)
    @address = address

    mail(:to      => address,
         :subject => "Sorry to see you go").deliver
  end

  def canceled(user)
    @user = user

    mail(:to      => "support@elmcitycraftworks.org",
         :subject => "[Practicing Ruby] Account cancellation").deliver
  end

  def failed_payment(user, charge)
    @user   = user
    @charge = charge

    mail(:to      => user.contact_email,
         :subject => "There was a problem with your payment for Practicing Ruby :(").deliver
  end

  def card_expiring(card)
    @card = card
    user  = card.user

    mail(:to      => user.contact_email,
         :subject => "Oh No! Your credit card is expiring next month.").deliver
  end
end

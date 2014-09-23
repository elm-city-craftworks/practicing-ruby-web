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

  def payment_created(user, payment)
    @payment = payment
    file = Tempfile.new('receipt.pdf')
    begin
      logo_image_path = File.expand_path("../assets/images/pr-logo.png",
                                   File.dirname(__FILE__))

      receipt = Prawn::Receipt.new :logo_image_path => logo_image_path,
                                   :company_name    => "Practicing Ruby",
                                   :company_email   => "gregory@practicingruby.com",
                                   :customer_email  => user.contact_email,
                                   :customer_name   => user.name,
                                   :amount_billed   => @payment.amount,
                                   :credit_card     => "xxxx-xxxx-xxxx-#{@payment.credit_card_last_four}",
                                   :transaction_id  => @payment.id

      receipt.render_file file.path

      attachments["receipt.pdf"] = File.read file.path
      mail(:to      => user.contact_email,
           :subject => "Receipt for your payment to practicingruby.com"
          ).deliver
    ensure
      file.close
      file.unlink
    end

    @payment.update_attributes(:email_sent => true)
  end

  def card_expiring(card)
    @card = card
    user  = card.user

    mail(:to      => user.contact_email,
         :subject => "Oh No! Your credit card is expiring next month.").deliver
  end

  def mailchimp_yearly_billing(user)
    @user = user

    mail(:to      => "support@elmcitycraftworks.org",
         :subject => "[Practicing Ruby] Mailchimp yearly billing request").deliver
  end
end

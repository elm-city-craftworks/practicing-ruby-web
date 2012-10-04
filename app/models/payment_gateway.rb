module PaymentGateway
  def self.for_user(user)
    case user.payment_provider
    when 'mailchimp'
      PaymentGateway::MailChimp.new(user)
    when 'stripe'
      PaymentGateway::Stripe.new(user)
    else # Default to stripe
      PaymentGateway::Stripe.new(user)
    end
  end
end
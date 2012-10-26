module PaymentGateway

  # TODO Enable MailChimp
  def self.for_user(user)
    PaymentGateway::Stripe.new(user)
  end

end
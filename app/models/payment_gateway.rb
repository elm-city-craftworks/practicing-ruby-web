module PaymentGateway
  def self.for_user(user)
    PaymentGateway::Stripe.new(user)
  end
end
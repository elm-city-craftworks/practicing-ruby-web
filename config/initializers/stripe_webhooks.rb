Stripe.api_key = STRIPE_SECRET_KEY

StripeEvent.setup do
  subscribe 'charge.failed' do |event|
    charge = event.data.object

    gateway = PaymentGateway::Stripe.for_customer(charge.customer)

    gateway.charge_failed(charge) if gateway
  end

  subscribe 'customer.subscription.deleted' do |event|
    subscription = event.data.object

    gateway = PaymentGateway::Stripe.for_customer(subscription.customer)

    gateway.subscription_ended if gateway
  end
end
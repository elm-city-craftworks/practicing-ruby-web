require_relative '../../test_helper'

class StripePaymentGatewayTest < ActiveSupport::TestCase

  setup do
    ActionMailer::Base.deliveries.clear

    @user            = FactoryGirl.create(:user, :payment_provider => 'stripe')
    @payment_gateway = @user.payment_gateway
  end

  test 'for_customer' do
    gateway = PaymentGateway::Stripe.for_customer(@user.payment_provider_id)

    assert gateway
  end

  test 'subscribe (success)' do
    skip_on_travis
    skip_if_no_stripe_key

    refute @user.subscriptions.active,
           "Should not have an active subscription before payment"

    gateway = PaymentGateway::Stripe.for_customer(@user.payment_provider_id)

    token =  Stripe::Token.create( :card => { :number => "4242424242424242",
                                              :exp_month => 8,
                                              :exp_year => Date.today.year + 2,
                                              :cvc => "314" })

    gateway.subscribe(:stripeToken => token.id, :interval => "month")

    assert @user.subscriptions.active,
          "Should have an active subscription after successful payment"
  end

  test 'subscribe (failure)' do
    skip_on_travis
    skip_if_no_stripe_key

    refute @user.subscriptions.active,
           "Should not have an active subscription before payment"

    gateway = PaymentGateway::Stripe.for_customer(@user.payment_provider_id)

    # The card number below is a specific stripe card number that will succeed
    # in being attached to a customer, but the charge will fail.
    #
    # See: https://stripe.com/docs/testing
    token =  Stripe::Token.create( :card => { :number => "4000000000000341",
                                              :exp_month => 8,
                                              :exp_year => Date.today.year + 2,
                                              :cvc => "313" })

    assert_raises(Stripe::CardError) do
      gateway.subscribe(:stripeToken => token.id, :interval => "month")
    end

    refute @user.subscriptions.active,
          "Should not have an active subscription after failed payment"
  end

  test 'subscription_ended' do
    subscription = Stripe::Charge.new

    @user.subscriptions.create(:start_date => Date.today)
    assert @user.subscriptions.active, "User does not have any active subscriptions"

    @payment_gateway.subscription_ended(subscription)

    assert @user.disabled?, "User is still enabled after their subscription ended"

    refute @user.subscriptions.active, "User's subscription was not ended"
  end

  test 'charge_failed' do
    charge = Stripe::Charge.construct_from(
      :failure_message => "Your card is terrible",
      :card => {
        :last4     => "5612",
        :exp_month => 1,
        :exp_year  => Date.today.year + 2
      })

    @payment_gateway.charge_failed(charge)

    message = ActionMailer::Base.deliveries.first

    assert message.body.to_s[/#{charge.card.last4}/], "Card number missing"
  end

  test 'payment_created' do
    invoice = FactoryGirl.build('support/stripe/invoice')

    @payment_gateway.payment_created(invoice)

    payment = @user.payments.where(:stripe_invoice_id => invoice.id).first

    assert_equal 100.0, payment.amount

    assert payment.email_sent, "Email not sent"

    message = ActionMailer::Base.deliveries.first

    assert message.body.to_s[/#{payment.invoice_date}/], "Invoice date missing"
  end
end

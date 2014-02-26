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
    skip_unless_stripe_configured

    refute @user.subscriptions.active,
           "Should not have an active subscription before payment"

    gateway = PaymentGateway::Stripe.for_customer(@user.payment_provider_id)
    token   = stripe_card_token

    gateway.subscribe(:stripeToken => token.id, :interval => "month")

    assert @user.subscriptions.active,
          "Should have an active subscription after successful payment"
  end

  test 'subscribe (failure)' do
    skip_unless_stripe_configured

    refute @user.subscriptions.active,
           "Should not have an active subscription before payment"

    gateway = PaymentGateway::Stripe.for_customer(@user.payment_provider_id)

    # The card number below is a specific stripe card number that will succeed
    # in being attached to a customer, but the charge will fail.
    #
    # See: https://stripe.com/docs/testing
    token = stripe_card_token(:number => "4000000000000341")

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

  test 'update_credit_card' do
    skip_unless_stripe_configured

    # First create a valid account in stripe which we can then update
    #
    gateway = PaymentGateway::Stripe.for_customer(@user.payment_provider_id)
    token   = stripe_card_token

    gateway.subscribe(:stripeToken => token.id, :interval => "month")

    assert_equal "4242", @user.credit_card.last_four, "Card last 4 not updated"

    # Next, update the credit card
    #
    token = stripe_card_token(:number => "4012888888881881")
    gateway.update_credit_card(:stripeToken => token.id)

    assert_equal "1881", @user.credit_card.reload.last_four,
      "Card last 4 not updated"
  end

  private

  def stripe_card_token(options = {})
    Stripe::Token.create(:card => {
      :number    => options.fetch(:number, "4242424242424242"),
      :exp_month => options.fetch(:exp_month, 8),
      :exp_year  => options.fetch(:exp_year, Date.today.year + 2),
      :cvc       => options.fetch(:cvc, "314")
    })
  end
end

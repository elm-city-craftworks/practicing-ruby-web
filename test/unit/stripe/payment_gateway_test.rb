require 'test_helper'

class StripePaymentGatewayTest < ActiveSupport::TestCase

  setup do
    ActionMailer::Base.deliveries.clear

    @user            = FactoryGirl.create(:user, :payment_provider => 'stripe')
    @payment_gateway = @user.payment_gateway

    @user.subscriptions.create(:start_date => Date.today)
  end

  test 'subscription_ended' do
    assert @user.subscriptions.active, "User does not have any active subscriptions"

    @payment_gateway.subscription_ended

    assert @user.disabled?, "User is still enabled after their subscription ended"

    refute @user.subscriptions.active, "User's subscription was not ended"

    # TODO test mail message
  end

  test 'charge_failed' do
    charge = Stripe::Charge.construct_from(
      :failure_message => "Your card is terrible",
      :card => {
        :last4     => "5612",
        :exp_month => 1,
        :exp_year  => 2013
      })

    @payment_gateway.charge_failed(charge)

    message = ActionMailer::Base.deliveries.first

    assert message.body.to_s[/#{charge.card.last4}/],      "Card number missing"
    assert message.body.to_s[/#{charge.failure_message}/], "Failure message missing"
  end
end

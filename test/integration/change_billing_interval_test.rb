require_relative "../test_helper"

# Monkey patching so Stripe::CardError plays nice with Mocha::Expectation#raises
#
module Stripe
  class CardError
    def initialize(message, param=nil, code=nil, http_status=nil, http_body=nil, json_body=nil)
      super(message, http_status, http_body, json_body)
      @param = param
      @code = code
    end
  end
end

class ChangeBillingIntervalTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
  end

  test "can change to yearly billing" do
    simulated_user.
      register(Support::SimulatedUser.default).
      change_billing_interval

    assert_equal "year", User.first.subscriptions.active.interval
  end

  test "can change to monthly billing" do
    simulated_user.
      register(Support::SimulatedUser.default.merge(:billing_interval => 'year')).
      change_billing_interval

    assert_equal "month", User.first.subscriptions.active.interval
  end

  test "gracefully reports card errors when changing billing methods" do
    skip_unless_stripe_configured

    PaymentGateway::Stripe.any_instance.stubs(:change_interval).raises(
      Stripe::CardError, "Your card was declined.")

    simulated_user.
      register(Support::SimulatedUser.default).
      change_billing_interval(stripe: true)

    assert_equal "month", User.first.subscriptions.active.interval

    assert_content "declined"
  end
end

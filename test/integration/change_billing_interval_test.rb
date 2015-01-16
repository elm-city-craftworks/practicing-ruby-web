require_relative "../test_helper"

class StubCardError < Stripe::CardError
  def initialize(message)
    super(message, nil, nil, nil, nil, nil)
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
      StubCardError, "Your card was declined.")

    simulated_user.
      register(Support::SimulatedUser.default).
      change_billing_interval(stripe: true)

    assert_equal "month", User.first.subscriptions.active.interval

    assert_content "declined"
  end
end

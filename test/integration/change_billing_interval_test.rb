require_relative "../test_helper"

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
    skip "change_billing_interval in SimulatedUser doesn't hit Stripe"

    PaymentGateway::Stripe.any_instance.stubs(:change_interval).returns do
      raise Stripe::InvalidRequestError.new("Your card was declined.")
    end

    simulated_user.
      register(Support::SimulatedUser.default).
      change_billing_interval

    assert_equal "monthly", User.first.subscriptions.active.interval

    assert_content "declined"
  end
end

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
end

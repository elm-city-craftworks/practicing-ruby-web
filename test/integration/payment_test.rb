require 'test_helper'

class PaymentTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = :webkit
    timeout = 15
  end

  test "valid payments activate user account" do
    skip_on_travis

    simulated_user do
      register(Support::SimulatedUser.default)
      make_stripe_payment
    end
  end
end
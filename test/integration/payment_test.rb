require 'test_helper'

class PaymentTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = :webkit
    timeout = 15
  end

  test "valid payments activate user account" do
    simulated_user do
      register(Support::SimulatedUser.default)
      make_stripe_payment
    end
  end
end
require 'test_helper'

class PaymentTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = :webkit
  end

  test "valid payments activate user account" do
    simulated_user do
      register(Support::SimulatedUser.default)
      make_stripe_payment
    end
  end

  test "coupon codes can be applied to payments" do
    simulated_user do
      register(Support::SimulatedUser.default)
      make_stripe_payment(:coupon => "test")
    end
  end
end
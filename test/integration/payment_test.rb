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

  test "credit card can be updated" do
    simulated_user do
      register(Support::SimulatedUser.default)
      make_stripe_payment
      update_credit_card
    end
  end

  test "failed credit card updates" do
    begin
      simulated_user do
        register(Support::SimulatedUser.default)
        make_stripe_payment
        update_credit_card(:card => "4000000000000002")
      end

      flunk "Invalid credit card was accepted"
    rescue Capybara::TimeoutError => e
      assert_flash "Your card was declined"
    end
  end

  test "failed payments" do
    begin
      simulated_user do
        register(Support::SimulatedUser.default)
        make_stripe_payment(:card => "4000000000000002")
      end

      flunk "Payment did not fail"

    rescue Capybara::TimeoutError => e
      assert_current_path registration_create_payment_path
      assert_content "Your card was declined"
    end
  end
end
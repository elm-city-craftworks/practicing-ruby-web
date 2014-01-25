require_relative "../test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
  end

  test "initiates the signup process" do
    simulated_user.click_subscribe
  end

  test "successful registration" do
    params = Support::SimulatedUser.default.merge(
      :cc_number => "4242424242424242",
      :cc_cvc    => "123",
      :cc_month  => 1,
      :cc_year   => Date.today.year + 1
    )

    simulated_user
      .authenticate(params)
      .make_payment(params)

    assert_content "Thanks"
  end

  test "successful registration with extraneous whitespace in email" do
    simulated_user
      .authenticate(:nickname => "TestUser", :uid => "12345")
      .make_db_payment(Support::SimulatedUser.default.merge(
        :email => "test@test.com "))
  end


  test "failed registration due to missing email" do
    simulated_user
      .authenticate(:nickname => "TestUser", :uid => "12345")
      .make_stripe_payment

    assert_content "This value is required."
  end

  test "failed registration due to invalid email" do
    simulated_user
      .authenticate(:nickname => "TestUser", :uid => "12345")
      .make_stripe_payment(:email => "Jordan dot Byron at Gmail dot com")

    assert_content "This value should be a valid email."
  end

  test "leaving registration process midstream" do
    user_params = {:nickname => "TestUser", :uid => "12345"}

    simulated_user
      .authenticate(user_params)
      .logout
      .authenticate(user_params)

    assert_current_path new_subscription_path
  end

  test "payment failure" do
    simulated_user
      .register(Support::SimulatedUser.default)
      .payment_failure
  end

  test "restarting registration process after payment failure" do
    simulated_user
      .register(Support::SimulatedUser.default)
      .payment_failure
      .restart_registration
      .register(Support::SimulatedUser.default)
  end


  test "attempting to confirm twice" do
    simulated_user
      .authenticate(Support::SimulatedUser.default)
      .make_db_payment(Support::SimulatedUser.default)
      .confirm_email(2)
  end
end

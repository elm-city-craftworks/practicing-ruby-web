require_relative "../test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest
  test "initiates the signup process" do
    simulated_user.click_subscribe
  end

  test "successful registration" do
    simulated_user
      .authenticate(:nickname => "TestUser", :uid => "12345")
      .create_profile(:email => "test@test.com")
      .confirm_email
      .make_payment
  end

  test "successful registration with extraneous whitespace in email" do
    simulated_user
      .authenticate(:nickname => "TestUser", :uid => "12345")
      .create_profile(:email => "test@test.com ")
      .confirm_email
      .make_payment
  end


  test "failed registration due to missing email" do
    simulated_user
      .authenticate(:nickname => "TestUser", :uid => "12345")
      .create_profile

    assert_content "Contact email is invalid"
  end

  test "failed registration due to invalid email" do
    simulated_user
      .authenticate(:nickname => "TestUser", :uid => "12345")
      .create_profile(:email => "Jordan dot Byron at Gmail dot com")

    assert_content "Contact email is invalid"
  end

  test "leaving registration process midstream" do
    user_params = {:nickname => "TestUser", :uid => "12345"}

    simulated_user
      .authenticate(user_params)
      .create_profile(:email => "test@test.com")
      .logout
      .authenticate(user_params)

    assert_current_path registration_update_profile_path
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
      .authenticate(:nickname => "TestUser", :uid => "12345")
      .create_profile(:email => "test@test.com")
      .confirm_email(2)
      .make_payment
  end

  test "payment pending accounts" do
    simulated_user
      .register(Support::SimulatedUser.default)
      .payment_pending
  end
end

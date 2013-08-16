require "test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest
  test "initiates the signup process" do
    simulated_user do
      click_subscribe
    end
  end

  test "successful registration" do
    simulated_user do
      authenticate(:nickname => "TestUser", :uid => "12345")
      create_profile(:email => "test@test.com")
      confirm_email
      make_payment
    end
  end

  test "successful registration with extraneous whitespace in email" do
    simulated_user do
      authenticate(:nickname => "TestUser", :uid => "12345")
      create_profile(:email => "test@test.com ")
      confirm_email
      make_payment
    end
  end


  test "failed registration due to missing email" do
    simulated_user do
      authenticate(:nickname => "TestUser", :uid => "12345")
      create_profile
    end

    assert_content "Contact email is invalid"
  end

  test "failed registration due to invalid email" do
    simulated_user do
      authenticate(:nickname => "TestUser", :uid => "12345")
      create_profile(:email => "Jordan dot Byron at Gmail dot com")
    end

    assert_content "Contact email is invalid"
  end

  test "leaving registration process midstream" do
    user_params = {:nickname => "TestUser", :uid => "12345"}

    simulated_user do
      authenticate(user_params)
      create_profile(:email => "test@test.com")
      logout
      authenticate(user_params)
    end

    assert_current_path registration_update_profile_path
  end

  test "payment failure" do
    simulated_user do
      register(Support::SimulatedUser.default)
      payment_failure
    end
  end

  test "restarting registration process after payment failure" do
    simulated_user do
      register(Support::SimulatedUser.default)
      payment_failure
      restart_registration
      register(Support::SimulatedUser.default)
    end
  end

  test "attempting to confirm twice" do
    simulated_user do
      authenticate(:nickname => "TestUser", :uid => "12345")
      create_profile(:email => "test@test.com")
      confirmation_path = confirm_email
      browser { visit confirmation_path } # this attempts to hit the secret URL again 
      make_payment
    end
  end

  test "payment pending accounts" do
    simulated_user do
      register(Support::SimulatedUser.default)
      payment_pending
    end
  end
end

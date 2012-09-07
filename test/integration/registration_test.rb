require "test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest
  test "successful registration" do
    simulate do
      authenticate(:nickname => "TestUser", :uid => "12345")
      edit_profile(:email => "test@test.com")
      confirm_email
      make_payment
    end
  end

  test "failed registration due to missing email" do
    simulate do
      authenticate(:nickname => "TestUser", :uid => "12345")
      edit_profile
    end

    assert_content "Contact email can't be blank"
  end

  test "leaving registration process midstream" do
    user_params = {:nickname => "TestUser", :uid => "12345"}

    simulate do
      authenticate(user_params)
      edit_profile(:email => "test@test.com")
      logout
      authenticate(user_params)
    end

    assert_current_path registration_update_profile_path
  end

  def simulate(&block)
    Support::SimulatedUser.new(self).instance_eval(&block)
  end
end

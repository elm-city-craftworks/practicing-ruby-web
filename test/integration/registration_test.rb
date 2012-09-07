require "test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest
  test "successful registration" do
    simulate do
      authenticate
      edit_profile(:email => "test@test.com")
      confirm_email
      make_payment
    end
  end

  test "failed registration due to missing email" do
    simulate do
      authenticate
      edit_profile
    end

    pending
  end

  def simulate(&block)
    Support::SimulatedUser.new(self).instance_eval(&block)
  end
end

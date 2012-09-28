require 'test_helper'

class ProfileTest < ActionDispatch::IntegrationTest

  test "contact email is validated" do
    simulated_user do
      register(Support::SimulatedUser.default)
      edit_profile(:email => "jordan byron at gmail dot com")
    end

    assert_content "Contact email is invalid"
  end
end
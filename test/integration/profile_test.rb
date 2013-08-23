require_relative "../test_helper"

class ProfileTest < ActionDispatch::IntegrationTest
  test "contact email is validated" do
    simulated_user
      .register(Support::SimulatedUser.default)
      .edit_profile(:email => "jordan byron at gmail dot com")

    assert_content "Contact email is invalid"
  end
end

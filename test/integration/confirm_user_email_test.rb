require_relative "../test_helper"

class ConfirmUserEmailTest < ActionDispatch::IntegrationTest
  test "warning is displayed when email hasn't been confirmed" do
    simulated_user.register(Support::SimulatedUser.default)

    assert_content "Your email address isn't verified yet"
  end

  test "warning is hidden when email is confirmed" do
    simulated_user
      .register(Support::SimulatedUser.default)
      .confirm_email

    assert_no_content "Your email address isn't verified yet"
  end

  test "confirmation email is re-sent when address kept the same" do
    Capybara.current_driver = Capybara.javascript_driver

    simulated_user
      .register(Support::SimulatedUser.default)
      .update_email_address
      .confirm_email
  end

  test "confirmation email is re-sent when address changed" do
    Capybara.current_driver = Capybara.javascript_driver

    simulated_user
      .register(Support::SimulatedUser.default)
      .update_email_address("new-address@practicingruby.com")
      .confirm_email
  end
end

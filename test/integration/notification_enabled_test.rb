require 'test_helper'

class NotificationEnabledTest < ActionDispatch::IntegrationTest
  setup do
    @authorization = FactoryGirl.create(:authorization)
    @user          = @authorization.user
    @user.update_attribute(:notifications_enabled, false)
  end

  test "notifications are turned on when a users sign in" do
    sign_user_in

    @user.reload

    assert @user.notifications_enabled,
           "Notifications were not enabled after sign in"
  end

end

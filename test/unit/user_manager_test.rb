require 'test_helper'
require 'mocha'

class UserManagerTest < ActiveSupport::TestCase
  context "disable_unsubscribed_users" do
    setup do
      @user_manager = UserManager.new
      @user_manager.stubs(:delete_user) # Don't try to delete users via the API
    end

    test "disables users which exist in the database" do
      to_be_disabled_user = FactoryGirl.create(:user)

      @user_manager.expects(:unsubscribed_users).returns([to_be_disabled_user.email])

      @user_manager.disable_unsubscribed_users

      to_be_disabled_user.reload # Load latest changes from the DB

      assert to_be_disabled_user.account_disabled, "Account not disabled"
    end

    test "deletes users in mail chimp" do
      to_be_disabled_user = FactoryGirl.create(:user)

      @user_manager.expects(:unsubscribed_users).returns([to_be_disabled_user.email])
      @user_manager.expects(:delete_user).with(to_be_disabled_user.email)

      @user_manager.disable_unsubscribed_users
    end
  end
end

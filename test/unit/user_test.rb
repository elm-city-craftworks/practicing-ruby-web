require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.create(:user)
  end

  context "status" do
    test "can not be updated through update_attributes" do
      @user.update_attributes(:status => "disabled")

      refute @user.status == "disabled", "User#status was updated"
    end

    test "can only be set to a valid status" do
      @user.status = "FAKE-STATUS"
      refute @user.save, "User#status set to an invalid status"
      assert @user.errors["status"].any?
    end
  end
end

require 'test_helper'

class UnsubscribeMailerTest < ActionMailer::TestCase
  context "mailchimp account is deleted" do

    test "user is notified they have been unsubscribed" do
      assert ActionMailer::Base.deliveries.empty?

      user = FactoryGirl.create(:user)
      user_manager = UserManager.new

      user_manager.stubs(:client).returns(mock(:list_unsubscribe))

      user_manager.delete_user(user.email)

      refute ActionMailer::Base.deliveries.empty?

      message = ActionMailer::Base.deliveries.first

      assert message.to.include?(user.email)
      assert message.subject == "Sorry to see you go"
    end

  end
end
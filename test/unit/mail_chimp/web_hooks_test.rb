require 'test_helper'
require 'mocha/setup'

class MailChimpWebHooksTest < ActiveSupport::TestCase

  test "handles unsupported request types" do
    request_type = "you don't know me"

    web_hook = MailChimp::WebHooks.new(:type => request_type)

    assert_equal request_type, web_hook.request_type

    process_result = web_hook.process

    assert process_result.include?("unsupported"),
           "Invalid process result '#{process_result}'"
  end

  test "does nothing when subscribe requests are made" do
    new_user = FactoryGirl.build(:user)

    params = user_to_mailchimp_params(new_user, "subscribe")

    web_hook = MailChimp::WebHooks.new(params)

    web_hook.process

    user = User.find_by_email(new_user.email)

    refute user, "New subscriber was created"
  end

  test "activates existing users if they subscribe again" do
    user = FactoryGirl.create(:user, :status => 'disabled')

    params = user_to_mailchimp_params(user, "subscribe")

    assert user.disabled?, "User account is already active"

    web_hook = MailChimp::WebHooks.new(params)

    web_hook.process

    user.reload # Load latest changes from DB

    refute user.disabled?, "User account was not enabled"
  end

  test "unsubscribed users accounts are disabled" do
    UserManager.any_instance.stubs(:delete_user) # Don't bother MailChimp

    user = FactoryGirl.create(:user)

    params = user_to_mailchimp_params(user, "unsubscribe")

    web_hook = MailChimp::WebHooks.new(params)

    web_hook.process

    user.reload # Load latest changes from DB

    assert user.disabled?, "User account was not disabled"
  end

  test "delete users don't throw errors when being unsubscribed" do
    UserManager.any_instance.stubs(:delete_user) # Don't bother MailChimp

    user = FactoryGirl.build(:user)

    params = user_to_mailchimp_params(user, "unsubscribe")

    web_hook = MailChimp::WebHooks.new(params)

    web_hook.process
  end

  test "unsubscribed users accounts are deleted from mailchimp" do
    user = FactoryGirl.create(:user)

    UserManager.any_instance.expects(:delete_user).with(user.email)

    params = user_to_mailchimp_params(user, "unsubscribe")

    web_hook = MailChimp::WebHooks.new(params)

    web_hook.process
  end

  test "deleted users accounts are disabled" do
    UserManager.any_instance.expects(:delete_user).never

    user = FactoryGirl.create(:user)

    params = user_to_mailchimp_params(user, "unsubscribe")

    params[:data][:action] = "delete"

    web_hook = MailChimp::WebHooks.new(params)

    web_hook.process
  end

  test "profile updates users information" do
    user = FactoryGirl.create(:user)

    params = user_to_mailchimp_params(user, "profile")

    params[:data][:merges][:FNAME] = "Jordan"
    params[:data][:merges][:LNAME] = "Byron"
    params[:data][:email]          = "jordan.byron@practicingruby.com"

    web_hook = MailChimp::WebHooks.new(params)

    web_hook.process

    user.reload # Load latest changes from DB

    assert_equal params[:data][:merges][:FNAME], user.first_name
    assert_equal params[:data][:merges][:LNAME], user.last_name
    assert_equal params[:data][:email],          user.email
  end

  test "find_user is not case sensitive" do
    user = FactoryGirl.create(:user)

    params = user_to_mailchimp_params(user, "profile")

    params[:data].delete(:web_id)
    params[:data][:email] = params[:data][:email].swapcase

    web_hook = MailChimp::WebHooks.new(params)
    assert_equal web_hook.find_user, user
  end

  private

  def user_to_mailchimp_params(user, request_type)
    { :type => request_type,
      :data => {
        :email  => user.email,
        :web_id => user.payment_provider_id,
        :merges => {
          :FNAME => user.first_name,
          :LNAME => user.last_name
        }
      }
    }
  end
end

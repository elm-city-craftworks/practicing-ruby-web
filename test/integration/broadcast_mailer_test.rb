require 'test_helper'

class BroadcastMailerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear

    @user = FactoryGirl.create(:user, :admin => true)
    FactoryGirl.create(:authorization, :user => @user)
  end

  test "messages are broadcast to users" do
    subject = "Weekly Update 1.5"
    body    = 100.times.map { "Long body content is long" }.join

    send_message :subject => subject, :body => body

    message = ActionMailer::Base.deliveries.first

    assert_equal subject, message.subject
    assert message.bcc.include?(@user.contact_email),
           "User missing from broadcast message"
  end

  test "only sends messages to users who have opted in" do
    no_updates_user = FactoryGirl.create(:user, :notify_updates => false)
    nothing_user    = FactoryGirl.create(:user, :notifications_enabled => false)

    send_message

    message = ActionMailer::Base.deliveries.first

    refute message.bcc.include?(no_updates_user.contact_email),
           "User was sent a broadcast message and they didn't want it"
    refute message.bcc.include?(nothing_user.contact_email),
           "User was sent a broadcast message and their notfications are disabled"
  end

  test "sending test copies" do
    send_message(:to => "support@elmcitycraftworks.com", :button => "Test")

    message = ActionMailer::Base.deliveries.first

    assert_equal ["support@elmcitycraftworks.com"], message.bcc
  end

  private

  def send_message(options = {})
    visit new_admin_broadcast_path

    fill_in 'to',      :with => options[:to] if options[:to]

    fill_in 'Subject', :with => options[:subject] || "Subject"
    fill_in 'Body',    :with => options[:body]    || "Body"

    click_button options[:button] || "Send"
  end
end
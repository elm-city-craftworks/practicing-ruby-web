require_relative '../test_helper'

class BroadcastMessagesTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear

    @admin = FactoryGirl.create(:user, :admin => true)
    FactoryGirl.create(:authorization, :user => @admin)
  end

  test "messages are broadcast to users" do
    users = 3.times.map { FactoryGirl.create(:user) } + [@admin]

    subject = "Weekly Update 1.5"
    body    = 100.times.map { "Long body content is long" }.join


    send_message(:subject => subject, :body => body)
    messages = ActionMailer::Base.deliveries

    users.each do |user|
      message = messages.find { |msg| msg.to == [user.contact_email] }
    
      assert message, "unable to find message for #{user.contact_email}"

      assert_equal subject, message.subject
      assert message.body.to_s[body]
    end
  end

  test "only sends messages to users who have opted in" do
    no_updates_user = FactoryGirl.create(:user, :notify_updates => false)
    nothing_user    = FactoryGirl.create(:user, :notifications_enabled => false)

    send_message

    ActionMailer::Base.deliveries.each do |message|
      refute message.to.include?(no_updates_user.contact_email),
             "User was sent a broadcast message and they didn't want it"

      refute message.to.include?(nothing_user.contact_email),
            "User was sent a broadcast message and their notifications are disabled"
    end
  end

  test "sending test copies" do
    send_message(:to => "support@elmcitycraftworks.com", :button => "Test")

    message = ActionMailer::Base.deliveries.first

    assert_equal ["support@elmcitycraftworks.com"], message.to
  end

  private

  def send_message(options = {})
    sign_user_in
    visit new_admin_broadcast_path

    fill_in 'to',      :with => options[:to] if options[:to]

    fill_in 'Subject', :with => options[:subject] || "Subject"
    fill_in 'Body',    :with => options[:body]    || "Body"

    case options[:button]
    when "Test" 
      click_button "Test"
    when nil
      click_button "Send"
    else
      raise NotImplementedError, "Don't know how to click #{options[:button]}"
    end
  end
end

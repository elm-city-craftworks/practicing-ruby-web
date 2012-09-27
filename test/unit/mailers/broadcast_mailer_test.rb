require 'test_helper'

class BroadcastMailerTest < ActionMailer::TestCase
  test "emails should not be escaped" do
    assert ActionMailer::Base.deliveries.empty?

    BroadcastMailer.deliver_broadcast(:body    => "It's working",
                                      :subject => "TEST",
                                      :to      => "test@test.com",
                                      :commit  => "Test")

    message = ActionMailer::Base.deliveries.first

    assert_equal "It's working\n", message.body.to_s
  end

  test "users without confirmed emails are not notified" do
    do_not_mail = %w{authorized pending_confirmation}.map do |status|
      FactoryGirl.create(:user, :status => status)
    end

    5.times { FactoryGirl.create(:user) }

    BroadcastMailer.deliver_broadcast(:body    => "Only you can see this",
                                      :subject => "TEST",
                                      :to      => "test@test.com")

    message = ActionMailer::Base.deliveries.first

    do_not_mail.each do |user|
      refute message.bcc.include?(user.contact_email),
        "User with status '#{user.status}' was sent a broadcast"
    end
  end
end

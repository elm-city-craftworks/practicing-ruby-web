require_relative '../../test_helper'

class BroadcastMailerTest < ActionMailer::TestCase
  test "users without confirmed emails are not notified" do
    do_not_mail = %w{authorized pending_confirmation}.map do |status|
      FactoryGirl.create(:user, :status => status)
    end

    5.times.map { FactoryGirl.create(:user) }

    BroadcastMailer.recipients.each do |email|
      BroadcastMailer.broadcast({:body    => "Only you all can see this",
                                :subject => "TEST"}, email).deliver
    end

    messages = ActionMailer::Base.deliveries

    assert_equal 5, messages.count

    do_not_mail.each do |user|
     refute messages.any? { |m| m.to.include?(user.contact_email) },
           "User with status '#{user.status}' was sent a broadcast"
    end
  end
end

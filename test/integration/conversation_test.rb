require_relative '../test_helper'


class ConversationTest < ActionDispatch::IntegrationTest
  setup do
    contacted_users     = 10.times.map { FactoryGirl.create(:user,
                                                            :notifications_enabled => true,
                                                            :notify_conversations  => true,
                                                            :notify_comment_made   => true,
                                                            :notify_mentions      => true) }

    not_contacted_users =  5.times.map { FactoryGirl.create(:user, 
                                                            :notifications_enabled => false) }

    @expected_contacted_emails = contacted_users.map { |e| e.contact_email }
  end

  test "creating a comment" do
    simulated_user
      .register(Support::SimulatedUser.default)
      .read_article
      .add_comment("This is wonderful!")

    outbox.has_message_with(:subject => /Conversation has started/,
                             :bcc     => @expected_contacted_emails)
  end

  test "creating multiple comments" do
    simulated_user
      .register(Support::SimulatedUser.default)
      .read_article
      .add_comment("This is wonderful!")
      .add_comment("And so is talking to myself!")
      .add_comment("Yaay!")

    outbox.has_message_with(:subject => /comment was added/,
                            :bcc     => @expected_contacted_emails,
                            :count   => 2)
 
  end
end

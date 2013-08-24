require_relative '../../test_helper'

class ConversationMailerTest < ActionMailer::TestCase
  context "conversation started" do

    test "users who wish to be notified are sent an email" do
      assert ActionMailer::Base.deliveries.empty?

      comment  = FactoryGirl.create(:comment, :body => "No mentions here")
      no_email = FactoryGirl.create(:user, :notify_conversations => false)

      assert ActionMailer::Base.deliveries.empty?
    end

    test "comment emails include a link back to article comments" do
      admin = FactoryGirl.create(:user, :admin => true, :github_nickname => "Jordan")

      first_comment   = FactoryGirl.create(:comment, :body => "First")
      mention_comment = FactoryGirl.create(:comment, :body => "@#{admin.github_nickname}",
        :commentable => first_comment.commentable)

      email_bodies = ActionMailer::Base.deliveries.map {|e| e.body.to_s }

      url = Rails.application.routes.url_helpers
                 .article_url(first_comment.commentable)

      email_bodies.each { |body| assert body[url] }
    end

    test "emails are not sent for non-published articles" do
      article = FactoryGirl.create(:article, :status => "draft")

      first_comment = FactoryGirl.create(:comment, :body        => "First Comment",
                                        :commentable => article)

      assert ActionMailer::Base.deliveries.empty?

      mention_comment = FactoryGirl.create(:comment,
        :body        => "Hi @#{first_comment.user.github_nickname}",
        :commentable => article)

      assert ActionMailer::Base.deliveries.empty?
    end

  end

  context "comment made" do

    test "emails are sent to users who wish to be notified" do
      assert ActionMailer::Base.deliveries.empty?

      notify_user      = FactoryGirl.create(:user, :notify_comment_made => true )
      dont_notify_user = FactoryGirl.create(:user, :notify_comment_made => false)

      first_comment = FactoryGirl.create(:comment, :body => "First Comment",
                                        :user => notify_user)

      ActionMailer::Base.deliveries.clear # Remove conversation started email

      assert ActionMailer::Base.deliveries.empty?

      second_comment = FactoryGirl.create(:comment, :body        => "Second Comment",
                                         :user        => dont_notify_user,
                                         :commentable => first_comment.commentable)

      messages = ActionMailer::Base.deliveries

      assert_equal 0, messages.count { |msg|
                        msg.bcc.include?(dont_notify_user.contact_email) }

      assert_equal 1, messages.count { |msg|
                        msg.bcc.include?(notify_user.contact_email) }

    end

    test "emails are sent to mentioned users" do
      assert ActionMailer::Base.deliveries.empty?

      user             = FactoryGirl.create(:user, :notify_conversations => false )
      dont_notify_user = FactoryGirl.create(:user, :notify_conversations => false)
      mentioned_user   = FactoryGirl.create(:user, :notify_conversations => false,
                                        :notify_comment_made  => true,
                                        :github_nickname      => "x" )

      FactoryGirl.create(:comment,
        :body        => "Hey @#{mentioned_user.github_nickname}",
        :user        => user)

      assert_equal 1, ActionMailer::Base.deliveries.count

      mentioned_email = ActionMailer::Base.deliveries.first

      assert mentioned_email.bcc.include?(mentioned_user.contact_email)
      refute mentioned_email.bcc.include?(user.contact_email)
      refute mentioned_email.bcc.include?(dont_notify_user.contact_email)
    end

  end

  context "Users with notifications disabled" do

    test "do not recieve conversation started emails" do
      assert ActionMailer::Base.deliveries.empty?

      user = FactoryGirl.create(:user, :notifications_enabled => false)

      first_comment = FactoryGirl.create(:comment, :body => "First Comment",
                                        :user => user)

      assert ActionMailer::Base.deliveries.empty?
    end

    test "do not recieve emails when mentioned" do
      # Users don't want to know about new conversations, so only a mention
      # email should be created for +dont_notify_user+, but in this case
      # he doesn't get anything

      user             = FactoryGirl.create(:user, :notify_conversations  => false)
      dont_notify_user = FactoryGirl.create(:user, :notify_mentions       => true,
                                        :notifications_enabled => false,
                                        :notify_conversations  => false,
                                        :github_nickname       => "not_me")

      FactoryGirl.create(:comment, :body => "Hey @#{dont_notify_user.github_nickname}",
                        :user => user )

      assert ActionMailer::Base.deliveries.empty?
    end

    test "do not recieve emails when comments are made" do
      user             = FactoryGirl.create(:user, :notify_conversations  => false)
      dont_notify_user = FactoryGirl.create(:user, :notify_comment_made   => true,
                                        :notifications_enabled => false,
                                        :notify_conversations  => false)
      # First comment
      first_comment = FactoryGirl.create(:comment, :body => "Oh yeah starting a conversation",
                                        :user => user )

      # Second comment
      FactoryGirl.create(:comment, :body => "But I'm just talking to myself",
                        :user => user,
                        :commentable => first_comment.commentable )

      assert ActionMailer::Base.deliveries.empty?
    end

  end
end

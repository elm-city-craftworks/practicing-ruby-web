require 'test_helper'

class ConversationMailerTest < ActionMailer::TestCase
  context "conversation started" do

    test "users who wish to be notified are sent an email" do
      assert ActionMailer::Base.deliveries.empty?

      comment = Factory(:comment, :body => "No mentions here")
      no_email = Factory(:user, :notify_conversations => false)

      refute ActionMailer::Base.deliveries.empty?

      message = ActionMailer::Base.deliveries.first

      assert message.bcc.include?(comment.user.email)
      refute message.bcc.include?(no_email.email)
    end

    test "comment emails include a link back to article comments" do
      admin = Factory(:user, :admin => true, :github_nickname => "Jordan")

      first_comment   = Factory(:comment, :body => "First")
      mention_comment = Factory(:comment, :body => "@#{admin.github_nickname}",
        :commentable => first_comment.commentable)

      email_bodies = ActionMailer::Base.deliveries.map {|e| e.body.to_s }

      article_url = Rails.application.routes.url_helpers.
        article_url( first_comment.commentable,
                     :anchor    => "comments",
                     :only_path => true )

      email_bodies.each do |body|
        assert body[article_url]
      end
    end

    test "emails are not sent for non-published articles" do
      article = Factory(:article, :status => "draft")

      first_comment = Factory(:comment, :body        => "First Comment",
                                        :commentable => article)

      assert ActionMailer::Base.deliveries.empty?

      mention_comment = Factory(:comment,
        :body        => "Hi @#{first_comment.user.github_nickname}",
        :commentable => article)

      assert ActionMailer::Base.deliveries.empty?
    end

  end

  context "comment made" do

    test "emails are sent to users who wish to be notified" do
      assert ActionMailer::Base.deliveries.empty?

      user             = Factory(:user, :notify_comment_made => true )
      dont_notify_user = Factory(:user, :notify_comment_made => false)

      first_comment = Factory(:comment, :body => "First Comment",
                                        :user => user)

      ActionMailer::Base.deliveries.clear # Remove conversation started email

      assert ActionMailer::Base.deliveries.empty?

      second_comment = Factory(:comment, :body        => "Second Comment",
                                         :user        => dont_notify_user,
                                         :commentable => first_comment.commentable)

      refute ActionMailer::Base.deliveries.first.bcc.include?(dont_notify_user.email)
      assert ActionMailer::Base.deliveries.first.bcc.include?(user.email)
    end

    test "emails are not sent to mentioned users" do
      assert ActionMailer::Base.deliveries.empty?

      user             = Factory(:user, :notify_comment_made => true )
      dont_notify_user = Factory(:user, :notify_comment_made => false)
      mentioned_user   = Factory(:user, :notify_comment_made => true,
                                        :github_nickname     => "x"  )

      first_comment = Factory(:comment, :body => "First Comment",
                                        :user => user)

      ActionMailer::Base.deliveries.clear # Remove conversation started email

      assert ActionMailer::Base.deliveries.empty?

      second_comment = Factory(:comment,
        :body        => "Hey @#{mentioned_user.github_nickname}",
        :user        => user,
        :commentable => first_comment.commentable)

      assert_equal 2, ActionMailer::Base.deliveries.count

      mentioned_email = ActionMailer::Base.deliveries.find {|e| e.subject[/mentioned/i] }

      assert mentioned_email.bcc.include?(mentioned_user.email)
      refute mentioned_email.bcc.include?(user.email)
      refute mentioned_email.bcc.include?(dont_notify_user.email)

      comment_email = ActionMailer::Base.deliveries.find {|e| e != mentioned_email }

      refute comment_email.bcc.include?(mentioned_user.email)
      assert comment_email.bcc.include?(user.email)
      refute comment_email.bcc.include?(dont_notify_user.email)
    end

  end
end
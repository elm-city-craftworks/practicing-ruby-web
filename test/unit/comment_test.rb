require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  context "mentioned_users" do
    test "returns an empty array if there are no mentions" do
      comment = Factory(:comment, :body => "No mentions here")

      assert_equal [], comment.mentioned_users
    end

    test "returns an empty array if no valid mentions are present" do
      comment = Factory(:comment,
        :body => "I mention @person but they don't exist")

      assert_equal [], comment.mentioned_users
    end

    test "returns an array of valid users mentioned" do
      person = Factory(:user, :github_nickname => "PerSon")
      frank  = Factory(:user, :github_nickname => "frank-pepelio")

      comment = Factory(:comment,
        :body => "I mention @PerSon and @frank-pepelio")

      mentioned_users = comment.mentioned_users

      assert_equal 2, mentioned_users.count
      assert mentioned_users.include?(person)
      assert mentioned_users.include?(frank)
    end

    test "omits mentioned users that do not have a matching user record" do
      frank  = Factory(:user, :github_nickname => "frank-pepelio")

      comment = Factory(:comment,
        :body => "I mention @frank-pepelio and @noexist")

      mentioned_users = comment.mentioned_users

      assert_equal [frank], mentioned_users
    end

    test "match mentioned users without case sensitivity" do
      frank  = Factory(:user, :github_nickname => "frank-pepelio")

      comment = Factory(:comment,
        :body => "I mention @FRANK-pepelio")

      mentioned_users = comment.mentioned_users

      assert_equal [frank], mentioned_users
    end

    test "allows user mentions to include punctuation" do
      frank   = Factory(:user, :github_nickname => "frank-pepelio")
      person  = Factory(:user, :github_nickname => "person")

      comment = Factory(:comment, :body => "@person, @frank-pepelio: YAY!")
      mentioned_users = comment.mentioned_users

      assert_equal 2, mentioned_users.count
      assert mentioned_users.include?(person)
      assert mentioned_users.include?(frank)
    end
  end
end

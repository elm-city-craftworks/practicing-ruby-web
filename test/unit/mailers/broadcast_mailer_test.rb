require_relative '../../test_helper'

class BroadcastMailerTest < ActionMailer::TestCase
  test "users without confirmed emails are not notified" do
    do_not_mail = %w{authorized pending_confirmation}.map do |status|
      FactoryGirl.create(:user, :status => status)
    end

    5.times { FactoryGirl.create(:user) }

    Broadcaster.notify_subscribers(:body    => "Only you all can see this",
                                   :subject => "TEST")

    messages = ActionMailer::Base.deliveries

    assert_equal 5, messages.count

    do_not_mail.each do |user|
      refute messages.any? { |m| m.to.include?(user.contact_email) },
            "User with status '#{user.status}' was sent a broadcast"
    end
  end

  test "article links can be generated from template" do
    user = FactoryGirl.create(:user)
    slug = "a-fancy-article"

    article = FactoryGirl.create(:article, :slug => slug)

    message_body = "Here's an amazing article\n{{#article}}#{slug}{{/article}}"

    Broadcaster.notify_subscribers(:body => message_body, :subject => "Hi there!")

    message = ActionMailer::Base.deliveries.first

    url =  ArticleLink.new(Article[slug]).url(user.share_token)

    expected_body = "Here's an amazing article\n#{url}"

    assert message.body.to_s[expected_body], "Expected link to be expanded, instead got: #{message.body.to_s}"
  end
end

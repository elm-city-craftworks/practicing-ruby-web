require 'test_helper'

class CommentDecoratorTest < ActiveSupport::TestCase
  setup do
    ApplicationController.new.set_current_view_context
  end

  test "parses at mentions and adds a link to the mentioned users profile" do
    frank   = FactoryGirl.create(:user, :github_nickname => "frank-pepelio")
    comment = FactoryGirl.create(:comment, :body => "@frank-pepelio: Hey dude!")

    comment = CommentDecorator.decorate(comment)

    assert comment.content[/<a href="\/users\/#{frank.github_nickname}"/],
           "@ mention link missing"
  end

  test "will not link to non-subscribers" do
    comment = FactoryGirl.create(:comment, :body => "@unknown: Who are you?")

    comment = CommentDecorator.decorate(comment)

    refute comment.content[/<a href="\/users\/unknown"/],
           "@ mention link present"

    assert comment.content[/@unknown/], "@ mention removed"
  end

  test "does not parse email addresses as mentions" do
    FactoryGirl.create(:user, :github_nickname => "jordanbyron")
    comment = FactoryGirl.create(:comment,
      :body => "Dude email me me@jordanbyron.com")

    comment = CommentDecorator.decorate(comment)

    refute comment.content[/<a href="\/users\//],
           "@ mention link present"
  end
end

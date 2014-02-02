require_relative '../../test_helper'

class CommentDecoratorTest < ActiveSupport::TestCase
  test "parses at mentions and adds a link to the mentioned users profile" do
    frank   = FactoryGirl.create(:user, :github_nickname => "frank-pepelio")
    comment = FactoryGirl.create(:comment, :body => "@frank-pepelio: Hey dude!")
    comment = comment.decorate

    assert comment.content[/<a href="\/users\/#{frank.github_nickname}"/],
           "@ mention link missing"
  end

  test "will not link to non-subscribers" do
    comment = FactoryGirl.create(:comment, :body => "@unknown: Who are you?")
    comment = comment.decorate

    refute comment.content[/<a href="\/users\/unknown"/],
           "@ mention link present"

    assert comment.content[/@unknown/], "@ mention removed"
  end

  test "does not parse email addresses as mentions" do
    FactoryGirl.create(:user, :github_nickname => "jordanbyron")
    comment = FactoryGirl.create(:comment,
      :body => "Dude email me me@jordanbyron.com")
    comment = comment.decorate

    refute comment.content[/<a href="\/users\//],
           "@ mention link present"
  end
end

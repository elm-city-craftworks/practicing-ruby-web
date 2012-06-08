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
end

require_relative '../test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  setup do
    simulated_user.register(Support::SimulatedUser.default)

    @article = FactoryGirl.create(:article, :slug => "awesome-article")

    visit article_path(@article)
  end

  test "can make a comment" do
    fill_in "comment_body", with: "I love this article"

    click_button "Comment"

    within("#comments") do
      assert_content "I love this article"
    end
  end

  test "requires comment text" do
    click_button "Comment"

    assert_content "Please enter some text"
  end
end

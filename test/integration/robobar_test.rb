require 'test_helper'

class RobobarTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = :webkit # You know, for the javascripts

    @authorization = Factory(:authorization)
    @user          = @authorization.user
    @article       = Factory(:article)

    sign_user_in

    visit article_path(@article)
  end

  test "chippy and his friends are added to article pages" do
    assert page.has_selector?('#chippy'), "Chippy was't loaded"
    assert page.has_selector?("#robo-bar"), "Robobar wasn't loaded"
  end

  test "robobar is shown when chippy is clicked" do
    find('#chippy').click

    assert find('#robo-bar').visible?, "Robobar isn't visible"
  end

  test "robobar has a share button" do
    find('#chippy').click

    within("#robo-bar") do
      assert_content "Share with your friends"
    end
  end

  test "share button opens the share panel and loads the share url" do
    find('#chippy').click

    find('#robo-bar button').click

    assert find('#robo-share').visible?, "Share panel isn't visible"

    skip "share doesn't exist right away and we need to wait a bit"

    share = SharedArticle.where(
      :article_id => @article.id, :user_id => @user.id
    ).first

    within("#robo-share") do
      assert_equal find('input').value, shared_article_url(share.secret)
    end
  end
end

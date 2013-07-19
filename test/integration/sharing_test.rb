require 'test_helper'

class SharingTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = :webkit # You know, for the javascripts

    @authorization = FactoryGirl.create(:authorization)
    @user          = @authorization.user
    @article       = FactoryGirl.create(:article)

    sign_user_in

    visit article_path(@article)
  end

  test "share button opens the share panel and loads the share url" do
    find('a.share').click

    assert find('#robo-share').visible?, "Share panel isn't visible"

    within("#robo-share") do
      share_link = find('input').value || '' # So the test fails gracefully

      share = SharedArticle.where(
        :article_id => @article.id, :user_id => @user.id
      ).first

      assert share_link[/#{shared_article_path(share.secret)}/],
        "Share URL appears invalid: #{share_link}"
    end
  end
end

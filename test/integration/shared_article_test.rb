require_relative '../test_helper'

class SharedArticleTest < ActionDispatch::IntegrationTest
  setup do
    @authorization = FactoryGirl.create(:authorization)
    @user          = @authorization.user
    @article       = FactoryGirl.create(:article)

    @share = SharedArticle.find_or_create_by_article_id_and_user_id(
      @article.id, @user.id)
  end

  test "shared article visible without logging in" do
    visit shared_article_path(@share.secret)

    assert_article_visible

    assert_content("subscribe")
    assert_content("log in")
  end

  test "shared article visible to logged in users" do
    sign_user_in
    visit shared_article_path(@share.secret)

    assert_article_visible

    assert_content("Sign out")
    assert_content("Share your thoughts:")
  end

  test "requesting invalid share key causes a 404 response" do
    visit shared_article_path("notarealkey")

    assert_equal 404, page.status_code
  end

  def assert_article_visible
    assert_equal 200, page.status_code

    assert_current_path Rails.application.routes.url_helpers.article_path(@article)
    assert_url_has_param "u", @share.user.share_token
  end
end

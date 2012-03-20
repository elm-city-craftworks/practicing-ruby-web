require 'test_helper'

class SharingTest < ActionDispatch::IntegrationTest
  setup do
    @authorization = Factory(:authorization)
    @user          = @authorization.user
    @article       = Factory(:article)
  end

  test "shared article visible without logging in" do
    assert_shared_article_accessible

    assert_no_content("Log out")
  end

  test "shared article visible to logged in users" do
    sign_user_in

    assert_shared_article_accessible

    assert_content("Log out")
  end

  def assert_shared_article_accessible
    share = SharedArticle.find_or_create_by_article_id_and_user_id(
      @article.id, @user.id)

    visit shared_article_path(share.secret)

    assert_equal shared_article_path(share.secret), current_path
  end
end

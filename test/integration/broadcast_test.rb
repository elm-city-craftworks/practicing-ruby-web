require 'test_helper'

class BroadcastTest < ActionDispatch::IntegrationTest

  setup do
    @authorization = FactoryGirl.create(:authorization)
    @user          = @authorization.user
    @article       = FactoryGirl.create(:article)
  end

  test "broadcasts are visible to logged in users" do
    announcement = FactoryGirl.create(:announcement, :broadcast => true)

    sign_user_in

    assert_content announcement.broadcast_message

    visit article_path(@article)

    assert_content announcement.broadcast_message

  end

  test "broadcasts are not visible when set to false" do
    announcement = FactoryGirl.create(:announcement, :broadcast => false)

    sign_user_in

    assert_no_content announcement.broadcast_message

    visit article_path(@article)

    assert_no_content announcement.broadcast_message
  end

  test "broadcasts are only visible when signed in" do
    announcement = FactoryGirl.create(:announcement, :broadcast => true)

    share = SharedArticle.find_or_create_by_article_id_and_user_id(
      @article.id, @user.id)

    visit shared_article_path(share.secret)

    assert_no_content announcement.broadcast_message

    sign_user_in

    assert_content announcement.broadcast_message
  end

end

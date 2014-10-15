require_relative '../test_helper'

class SharedArticleTest < ActionDispatch::IntegrationTest
  setup do
    @authorization = FactoryGirl.create(:authorization)
    @user          = @authorization.user
    @article       = FactoryGirl.create(:article)
  end

  test "shared article visible without logging in" do
    assert_article_visible(:guest)
  end

  test "shared article visit without logging in (draft)" do
    @article.update_attributes(:status => "draft")

    assert_article_visible(:guest)
  end

  test "shared article visible to logged in users" do
    sign_user_in

    assert_article_visible(:subscriber)
  end

  test "shared article visible to logged in users (draft)" do
    @article.update_attributes(:status => "draft")

    sign_user_in

    assert_article_visible(:subscriber)
  end

  (User::STATUSES - User::ACTIVE_STATUSES).each do |e|
    test "Users in status #{e} should be treated as guests" do
      unauthorized_user = FactoryGirl.create(:user, :status => e)
      @authorization.user = unauthorized_user
      @authorization.save

      sign_user_in

      assert_article_visible(:guest)
    end
  end


  test "requesting invalid share key causes a 404 response" do
    visit shared_article_path("notarealkey")

    assert_equal 404, page.status_code
  end

  def assert_article_visible(state)
    visit article_path(@article, :u => @user.share_token)

    assert_equal 200, page.status_code

    assert_current_path Rails.application.routes.url_helpers.article_path(@article)
    assert_url_has_param "u", @user.share_token

    case state
    when :guest
      assert_content("subscribing")
    when :subscriber
      assert_content("Share your thoughts:")
    else
      raise ArgumentError, "Invalid state: #{state}"
    end
  end
end

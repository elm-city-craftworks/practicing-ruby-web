require_relative "../test_helper"

class ArticleRoutingTest < ActionDispatch::IntegrationTest
  setup do
    @article = FactoryGirl.create(:article, :slug => "awesome-article")
    simulated_user.register(Support::SimulatedUser.default)

    # FIXME: Another simulated user oddity
    @user    = User.first
  end

  test "by slug" do
    visit "/articles/awesome-article"

    assert_content @article.subject

    assert_current_path "/articles/awesome-article"
    assert_url_has_param "u", @user.share_token
  end

  test "by id" do
    id = @article.id
    visit "/articles/#{id}"

    assert_content @article.subject

    assert_current_path "/articles/awesome-article"
    assert_url_has_param "u", @user.share_token
  end

  test "with invalid slug" do
    visit "/articles/i-do-no-exist"

    assert_equal 404, page.status_code
  end

  test "with invalid id" do
    visit "/articles/99999"

    assert_equal 404, page.status_code
  end
end

require_relative "../test_helper"

class ArticleRoutingTest < ActionDispatch::IntegrationTest
  setup do
    @article = FactoryGirl.create(:article, :slug => "awesome-article")
    simulated_user { register Support::SimulatedUser.default }
  end

  test "by slug" do
    visit "/articles/awesome-article"

    assert_content @article.subject
  end

  test "by id" do
    id = @article.id
    visit "/articles/#{id}"

    assert_content @article.subject

    assert_current_path "/articles/awesome-article"
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

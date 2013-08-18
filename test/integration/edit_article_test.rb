require_relative '../test_helper'

class EditArticleTest < ActionDispatch::IntegrationTest
  setup do
    simulated_user { register Support::SimulatedUser.default }
    @article = FactoryGirl.create(:article, :slug => "awesome-article")
    User.first.update_attribute(:admin, true)
  end

  test "can edit articles with slugs" do
    visit edit_admin_article_path(@article.slug)

    click_button "Update Article"

    assert_current_path article_path(@article)
  end

  test "can edit articles without slugs" do
    @article.update_attribute(:slug, nil)

    visit edit_admin_article_path(@article.id)

    click_button "Update Article"

    assert_current_path article_path(@article)
  end
end

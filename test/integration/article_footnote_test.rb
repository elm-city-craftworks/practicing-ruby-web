require_relative '../test_helper'

class ArticleFootnoteTest < ActionDispatch::IntegrationTest
  setup do
    @authorization = FactoryGirl.create(:authorization)
    @user          = @authorization.user
    @article       = FactoryGirl.create(:article)
  end

  test "article with footnotes has them rendered" do
    @article.update_attribute(:body, "
# Test Article

This paragraph should have a footnote after it.[^1]

This paragraph should not.

[^1]: This should appear as a footnote.
    ")

    sign_user_in

    visit article_path(@article.id)
    
    assert_css "a[rel=footnote]"
    assert_css ".footnotes li#fn1"
  end

  test "article with no footnotes does not render any" do
    @article.update_attribute(:body, "
# Test Article

This article has no footnotes.
    ")

    sign_user_in

    visit article_path(@article.id)

    assert_no_css "a[rel=footnote]"
    assert_no_css ".footnotes"
  end
end

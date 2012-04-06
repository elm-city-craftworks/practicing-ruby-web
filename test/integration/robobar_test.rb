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
end

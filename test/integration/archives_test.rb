require_relative "../test_helper"


class ArchivesTest < ActionDispatch::IntegrationTest
  # This test applies to guests, logged in users,
  # and logged out users alike.
  def self.archives_should_be_viewable
    test "archive should be viewable" do
      visit archives_path
      assert_current_path archives_path

      @articles.each { |a| assert_content a.subject }
    end
  end

  setup do
    @articles = 3.times.map { FactoryGirl.create(:article) }
  end 

  context "Unregistered user" do
    setup { set_user_state(:guest) }

    archives_should_be_viewable
  end

  context "Registered user -- logged out" do
    setup { set_user_state(:logged_out) }

    archives_should_be_viewable

    test "clicking a link from the archives forces a login" do
      visit archives_path

      click_link @articles[1].subject

      assert_current_path root_path
      assert_content "protected"

      click_link "Sign in"
      assert_current_path article_path(@articles[1])
    end
  end

  context "Registered user -- logged in" do
    setup { set_user_state(:logged_in) }

    archives_should_be_viewable

    test "clicking a link from the archives goes directly to the article" do
      visit archives_path

      click_link @articles[1].subject
      assert_current_path article_path(@articles[1])
    end
  end

  private

  ## FIXME: Clearly these tests are a sign that SimulatedUser isn't serving us
  # as well as it should here, but I'm not sure how to handle it for the moment.

  def set_user_state(state)
    raise ArgumentError unless [:logged_out, :logged_in, :guest].include?(state)

    return if state == :guest

    simulated_user.register(Support::SimulatedUser.default)
    simulated_user.logout unless state == :logged_in
  end
end

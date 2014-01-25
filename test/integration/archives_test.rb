require_relative "../test_helper"

class ArchivesTest < ActionDispatch::IntegrationTest
  setup do
    @articles = 3.times.map { FactoryGirl.create(:article) }
  end

  test "archive should be viewable" do
    visit archives_path
    assert_current_path archives_path

    @articles.each { |a| assert_content a.subject }
  end

  context "Public articles" do
    test "clicking a link from the archives goes directly to the article" do
      public_article = FactoryGirl.create(:article, :status => "public")

      visit archives_path

      click_link public_article.subject
      assert_current_path article_path(public_article)
    end
  end

  context "Subscriber-only articles" do
    test "Non-Subscribers are directed back and shown a warning" do
      visit archives_path

      click_link @articles[1].subject

      assert_current_path root_path
      assert_content "article hasn't been published yet"
    end

    test "Subscribers that are logged out must login" do
      set_user_state(:logged_out)

      visit archives_path

      click_link @articles[1].subject

      assert_current_path root_path
      assert_content "article hasn't been published yet"

      visit login_path
      assert_current_path article_path(@articles[1])
    end

    test "Subscribers that are logged in can view the article" do
      set_user_state(:logged_in)

      visit archives_path

      click_link @articles[1].subject

      assert_current_path article_path(@articles[1])
    end
  end

  context "Draft articles" do
    setup { @draft = FactoryGirl.create(:article, :status => "draft") }

    test "are not visible to registered users" do
      set_user_state(:logged_in)

      visit archives_path

      assert_no_content @draft.subject
    end

    test "are not visible to guests" do
      set_user_state(:guest)

      visit archives_path

      assert_no_content @draft.subject
    end

    test "are visible to admins" do
      set_user_state(:logged_in)

      user       = User.first
      user.admin = true
      user.save

      visit archives_path

      assert_content @draft.subject
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

require 'test_helper'

class AccountLinkingTest < ActionDispatch::IntegrationTest
  test "github autolinking" do
    Factory.create(:user, :email => "gregory.t.brown@gmail.com")

    OmniAuth.config.add_mock(:github, {
      :uid => '12345',
      :user_info => {
        :nickname => 'sandal',
        :email    => "gregory.t.brown@gmail.com"
      }
    })

    visit community_url

    auth_link = Authorization.find_by_github_uid("12345").
                              authorization_link


    assert_equal authorization_link_path(auth_link), current_path

    refute_empty ActionMailer::Base.deliveries

    mail = ActionMailer::Base.deliveries.first
    ActionMailer::Base.deliveries.clear

    assert_equal ["gregory.t.brown@gmail.com"], mail.to

    visit "/sessions/link/#{auth_link.secret}"
    assert_equal articles_path, current_path
  end

  test "github manual linking" do
    Factory.create(:user, :email => "gregory.t.brown@gmail.com")

    OmniAuth.config.add_mock(:github, {
      :uid => '12345',
      :user_info => {
        :nickname => 'sandal',
        :email    => "test@test.com"
      }
    })

    visit community_url

    auth_link = Authorization.find_by_github_uid("12345").
                              authorization_link


    assert_equal edit_authorization_link_path(auth_link), current_path
    fill_in "authorization_link_mailchimp_email", :with => "gregory.t.brown@gmail.com"
    click_button("Link this email address to my Github account")

    refute_empty ActionMailer::Base.deliveries
    mail = ActionMailer::Base.deliveries.first
    ActionMailer::Base.deliveries.clear

    assert_equal ["gregory.t.brown@gmail.com"], mail.to

    auth_link.reload

    visit "/sessions/link/#{auth_link.secret}"
    assert_equal articles_path, current_path
  end

end

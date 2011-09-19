require 'test_helper'

class AccountLinkingTest < ActionDispatch::IntegrationTest

  test "github autolinking" do
    email = "gregory.t.brown@gmail.com"
    uid   = "12345"

    create_user(:email => email)
    login(:nickname => "sandal", :email => email, :uid => uid)

    visit community_url

    auth_link = Authorization.find_by_github_uid(uid).
                              authorization_link

    assert_confirmation_sent(:link => auth_link, :email => email)

    assert_activated(auth_link)
  end

  test "github manual linking" do
    mailchimp_email = "gregory.t.brown@gmail.com"
    github_email    = "test@test.com"
    uid             = "12345"

    create_user(:email => mailchimp_email)
    login(:nickname => "sandal", :email => github_email, :uid => uid)

    visit community_url

    auth_link = Authorization.find_by_github_uid(uid).
                              authorization_link

    assert_email_manually_entered(:link  => auth_link, 
                                  :email => mailchimp_email)

    assert_confirmation_sent(:link  => auth_link, 
                             :email => mailchimp_email)

    assert_activated(auth_link)
  end

  def login(params)
    OmniAuth.config.add_mock(:github, {
      :uid => params[:uid],
      :user_info => {
        :nickname => params[:nickname],
        :email    => params[:email]
      }
    })
  end

  def create_user(params)
    Factory(:user, params)
  end

  def assert_confirmation_sent(params)
    assert_equal authorization_link_path(params[:link]), current_path

    refute_empty ActionMailer::Base.deliveries

    mail = ActionMailer::Base.deliveries.first
    ActionMailer::Base.deliveries.clear

    assert_equal [params[:email]], mail.to
  end

  def assert_email_manually_entered(params)
    assert_equal edit_authorization_link_path(params[:link]), current_path
    fill_in "authorization_link_mailchimp_email", 
      :with => params[:email]

    click_button("Link this email address to my Github account")

    params[:link].reload
  end

  def assert_activated(auth_link)
    visit "/sessions/link/#{auth_link.secret}"
    assert_equal articles_path, current_path
  end
end

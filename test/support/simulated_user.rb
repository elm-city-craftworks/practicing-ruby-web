module Support
  class SimulatedUser

    def self.default
      {
        :nickname => "TestUser",
        :uid      => "12345",
        :email    => "test@test.com"
      }
    end

    def initialize(browser)
      @browser = browser
    end

    def authenticate(params)
      OmniAuth.config.add_mock(:github, {
        :uid => params[:uid],
        :info => {
          :nickname => params[:nickname],
          :email    => params.fetch(:email, "")
        }
      })

      browser { visit login_path }

      @user = Authorization.find_by_github_uid(params[:uid]).user
    end

    def register(params)
      authenticate(params)
      create_profile(params)
      confirm_email
      make_payment
      read_article
    end

    def create_profile(params={})
      browser do
        visit registration_edit_profile_path
        fill_in "Email:", :with => params.fetch(:email, "")
        click_button "Continue"
      end
    end

    def confirm_email
      browser { assert_current_path registration_update_profile_path }

      mail   = ActionMailer::Base.deliveries.pop
      base   = Rails.application.routes.url_helpers.
                 registration_confirmation_path(:secret => "")

      secret = mail.body.to_s[/#{base}(\h+)/,1]

      browser do
        visit registration_confirmation_path(:secret => secret)
      end
    end

    def make_payment
      browser do
        assert_current_path registration_payment_pending_path
      end

      # TODO Find a way to test this through the UI
      #
      @user.subscriptions.create(:start_date => Date.today)
    end

    def read_article
      article = FactoryGirl.create(:article)

      browser do
        visit article_path(article)
        assert_current_path article_path(article)
      end

      @browser.assert @user.subscriptions.active, "No active subscription"
    end

    def make_stripe_payment(params={})
      @user.subscriptions.delete_all

      browser do
        skip_on_travis

        timeout = 15

        visit registration_payment_path

        card  = find(:css, "input.card-number")
        cvc   = find(:css, "input.card-cvc")
        month = find(:css, "select.card-expiry-month")
        year  = find(:css, "select.card-expiry-year")

        card.set  "4242424242424242"
        cvc.set   "123"
        month.set "January"
        year.set  Date.today.year + 1

        fill_in "Coupon", :with => params.fetch(:coupon, "")

        click_button "Submit Payment"

        wait_until { current_path == registration_complete_path }

        assert_content "Thanks for subscribing"

        visit library_path
        assert_current_path library_path
      end
    end

    def payment_failure
      @user.disable

      browser do
        visit library_path
        assert_current_path problems_sessions_path
      end
    end

    def cancel_account
      browser do
        click_link     "Settings"
        click_link     "Unsubscribe from Practicing Ruby"

        assert_content "Sorry to see you go"

        message = ActionMailer::Base.deliveries.first

        assert message.to.include?("support@elmcitycraftworks.org")
        assert message.subject[/cancellation/]

        visit library_path
        assert_current_path problems_sessions_path
      end

      @browser.refute @user.subscriptions.active, "Subscription was not ended"
    end

    def restart_registration
      browser do
        click_link "subscribing"
        assert_current_path registration_edit_profile_path
      end
    end

    def edit_profile(params={})
      browser do
        click_link "Settings"
        fill_in "Email:", :with => params.fetch(:email, "")
        click_button "Update Settings"
      end
    end

    def logout
      browser { visit logout_path }
    end

    private

    def browser(&block)
      @browser.instance_eval(&block)
    end
  end
end

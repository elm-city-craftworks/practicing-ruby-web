module Support
  class SimulatedUser
    class Proxy
      def initialize(target)
        @target = target
      end

      def method_missing(*a, &b)
        @target.send(*a, &b)
        self
      end
    end

    def self.default
      {
        :nickname  => "TestUser",
        :uid       => "12345",
        :email     => "test@test.com"
      }
    end

    def self.new(browser)
      Proxy.new(super)
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
      make_db_payment(params)
      read_article
    end

    def confirm_email(attempts=1)
      # NOTE This method assumes a confirmation email is waiting in the queue.
      mail = ActionMailer::Base.deliveries.pop
      base = Rails.application.routes.url_helpers.
                 confirm_email_path(:secret => "")

      secret = mail.body.to_s[/#{base}(\h+)/,1]

      browser do
        attempts.times { visit confirm_email_path(:secret => secret) }
        assert_no_content "Your email address isn't verified yet"
      end
    end

    def make_payment(params={})
      if ENV['STRIPE'].present?
        make_stripe_payment(params)
      else
        make_db_payment(params)
      end
    end

    # Manual version of make_stripe_payment
    #
    def make_db_payment(params={})
      browser { assert_current_path new_subscription_path }

      @user.subscriptions.create(
        :start_date       => Date.today,
        :payment_provider => "stripe",
        :rate_cents       => params.fetch(:billing_rate, 800),
        :interval         => params.fetch(:billing_interval, 'month'))

      @user.email  = params[:email]
      @user.status = "active"
      @user.save

      browser { visit articles_path(:new_subscription => true) }
    end

    def make_stripe_payment(params={})
      browser do
        assert_current_path new_subscription_path

        fill_in "Email Address", :with => params.fetch(:email, "")
        choose  "interval_#{params.fetch(:billing_interval, 'month')}"

        find('input.card-number').set        params.fetch(:cc_number, '')
        find('input.card-cvc').set           params.fetch(:cc_cvc, '')
        find('select.card-expiry-month').set params.fetch(:cc_month, '')
        find('select.card-expiry-year').set  params.fetch(:cc_year, '')

        click_button "❤  Subscribe to Practicing Ruby"

        # Wait for ajax to complete
        Capybara.default_wait_time = 10
        assert has_no_css? "#processing-spinner.spinning"
      end
    ensure
      Capybara.default_wait_time = 3
    end

    def read_article
      article = FactoryGirl.create(:article)

      browser do
        visit article_path(article)
        assert_current_path article_path(article)
      end

      @browser.assert @user.subscriptions.active, "No active subscription"
    end

    def add_comment(message)
      browser do
        fill_in "comment_body", :with => message
        click_button "Comment"

        assert_content(message)
      end
    end

    def payment_failure
      @user.disable

      browser do
        visit profile_settings_path
        assert_current_path problems_sessions_path
      end
    end

    def cancel_account
      ActionMailer::Base.deliveries.clear

      browser do
        visit root_path
        click_link "Settings"
        click_link "Unsubscribe from Practicing Ruby"

        assert_content "Sorry to see you go"

        message = ActionMailer::Base.deliveries.first

        assert message.to.include?("support@elmcitycraftworks.org")
        assert message.subject[/cancellation/]

        # Cancellation is manual, so the subscriber will still have access
        # temporarily...
        visit articles_path
        assert_current_path articles_path
      end

      # once Jia gets around to it...
      @user.disable

      browser do
        visit profile_settings_path
        assert_current_path problems_sessions_path
      end

      @browser.refute @user.subscriptions.active, "Subscription was not ended"
    end

    def change_billing_interval
      current_interval = @user.subscriptions.active.interval

      browser do
        visit root_path
        click_link "Settings"
        click_link "Billing"
        click_link "change-billing-interval"

        within "#facebox" do
          assert /Change to (yearly|monthly) billing/ =~ first(:link).text
        end
      end

      # FIXME Simulate billing switch
      subscription = @user.subscriptions.active.decorate
      subscription.update_attributes(:finish_date => Date.today)

      @user.subscriptions.create(
        :start_date       => Date.today,
        :payment_provider => 'stripe',
        :rate_cents       => 800,
        :interval         => subscription.alternate_billing_interval
      )

      @browser.refute_equal @user.subscriptions.active.interval,
                            current_interval
    end

    def update_email_address(email=nil)
      # Remove original confirmation email if present
      ActionMailer::Base.deliveries.clear

      browser do
        click_link "update your contact info"

        fill_in("Email Address", :with => email) if email

        click_button "Send confirmation email"

        assert_content "Email updated"
      end
    end

    def restart_registration
      browser do
        click_link "subscribing"
        assert_current_path new_subscription_path
      end
    end

    def edit_profile(params={})
      browser do
        visit root_path
        click_link "Settings"
        fill_in "Email Address", :with => params.fetch(:email, "")
        click_button "Update Settings"
      end
    end

    def logout
      browser { visit logout_path }
    end

    def click_subscribe
      default = self.class.default

      # FIXME: This is a bit of a hack, and duplicates the authenticate() method
      OmniAuth.config.add_mock(:github, {
        :uid => default[:uid],
        :info => {
          :nickname => default[:nickname],
          :email    => default.fetch(:email, "")
        }
      })

      browser do
        visit root_path
        click_link "Subscribe"

        # Signup facebox
        click_button "Sign up via Github"

        assert_current_path new_subscription_path
      end
    end

    private

    def browser(&block)
      @browser.instance_eval(&block)
    end
  end
end

module Support
  class SimulatedUser
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

    def edit_profile(params={})
      browser do
        visit registration_edit_profile_path
        fill_in "Email:", :with => params.fetch(:email, "")
        click_button "Continue"
      end
    end

    def confirm_email
      mail   = ActionMailer::Base.deliveries.pop
      base   = Rails.application.routes.url_helpers.
                 registration_confirmation_path(:secret => "")

      secret = mail.body.to_s[/#{base}(\h+)/,1]

      browser do
        visit registration_confirmation_path(:secret => secret)
      end
    end

    def make_payment
      browser { assert_current_path registration_payment_path }
    end

    def payment_failure
      @user.disable

      browser do
        visit library_path
        assert_current_path problems_sessions_path
      end
    end

    def restart_registration
      browser do
        click_link "subscribing"
        assert_current_path registration_edit_profile_path
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

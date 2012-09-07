module Support
  class SimulatedUser
    def initialize(browser)
      @browser = browser
      @user    = FactoryGirl.create(:user)
    end

    def authenticate
      FactoryGirl.create(:authorization, :user => @user) 

      browser { visit login_path }
    end

    def edit_profile(params={})
      browser do
        visit registration_edit_profile_path 
        fill_in "Email:", :with => params.fetch(:email, "")
        click_button "Continue"
      end
    end

    # FIXME: Use dynamic routes
    def confirm_email
      mail   = ActionMailer::Base.deliveries.pop
      base   = "http://practicingruby.com/registration/confirm_email/"

      secret = mail.body.to_s[/#{base}(\h+)/,1]

      browser do
        visit registration_confirmation_path(:secret => secret)
      end
    end

    def make_payment
      browser { assert_current_path registration_payment_path }
    end

    private

    def browser(&block)
      @browser.instance_eval(&block)
    end
  end
end

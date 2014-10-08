module Support
  module Integration
    def assert_css(css, options={})
      assert has_css?(css, options),
        "CSS #{css.inspect} with options #{options.inspect} does not exist"
    end

    def assert_no_css(css, options={})
      assert !has_css?(css, options),
        "CSS #{css.inspect} with options #{options.inspect} exists"
    end

    def assert_current_path(expected_path)
      assert_equal expected_path, current_path
    end

    def assert_errors(*error_list)
      within "#errorExplanation" do
        error_list.each do |error_message|
          assert_content error_message
        end
      end
    end

    def assert_field(label, options={})
      assert has_field?(label, options),
        "Field #{label.inspect} with options #{options.inspect} does not exist"
    end

    def assert_no_field(label, options={})
      assert has_no_field?(label, options),
        "Field #{label.inspect} with options #{options.inspect} exists"
    end

    def assert_flash(message)
      assert has_css?('#flash', :text => message),
        "Flash #{message.inspect} does not exist in the page"
    end

    def assert_link(text)
      assert has_link?(text), "Link #{text} does not exist in the page"
    end

    def assert_no_link(text)
      assert has_no_link?(text), "Link #{text} exists in the page"
    end

    def assert_link_to(url, options={})
      assert_css "a[href='%s']" % url, options
    end

    def assert_content(content)
      assert has_content?(content), "Content #{content.inspect} does not exist"
    end

    def assert_no_content(content)
      assert has_no_content?(content), "Content #{content.inspect} exist"
    end

    def assert_title(title)
      within('title') do
        assert has_content?(title), "Title #{title.inspect} does not exist"
      end
    end

    def click_link_within(scope, text)
      within(scope) { click_link(text) }
    end

    def sign_user_in
      visit login_path
    end

    def sign_out
      click_link 'Log out'
    end

    # FIXME: THIS IS ALMOST CERTAINLY A HACK.
    def assert_url_has_param(key, value)
      params =  Rack::Utils.parse_query(URI.parse(current_url).query)

      assert_equal params[key], value
    end

    def within(scope, prefix=nil)
      scope = '#' << ActionController::RecordIdentifier.dom_id(scope, prefix) if scope.is_a?(ActiveRecord::Base)
      super(scope)
    end

    def simulated_user
      if block_given?
        raise "Block interface has been removed. Make direct method calls instead"
      end

      Support::SimulatedUser.new(self)
    end

    # Screenshot
    def ss
      Capybara::Screenshot.screen_shot_and_open_image
    end

    def outbox
      Support::Outbox.new(self, ActionMailer::Base.deliveries)
    end

    def fill_in_card(params = {})
      card  = find(:css, "input.card-number")
      cvc   = find(:css, "input.card-cvc")
      month = find(:css, "select.card-expiry-month")
      year  = find(:css, "select.card-expiry-year")

      card.set  params.fetch(:card,  "4242424242424242")
      cvc.set   params.fetch(:cvc,   "123")
      month.set params.fetch(:month, "1")
      year.set  params.fetch(:year,  Date.today.year + 2)
    end
  end
end

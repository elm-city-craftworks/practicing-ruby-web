ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/integration'
require 'support/mini_contest'
require 'test_notifier/runner/minitest'
require 'capybara/rails'
require 'database_cleaner'

TestNotifier.silence_no_notifier_warning = true
DatabaseCleaner.strategy                 = :truncation
OmniAuth.config.test_mode                = true

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Support::Integration

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  setup do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = {
      'provider'  => "github",
      'uid'       => '12345',
      'user_info' => { 'nickname' => 'frankpepelio' }
    }

    Factory(:article)
  end

  teardown do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end


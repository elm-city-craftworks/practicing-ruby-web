ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/integration'
require 'support/mini_contest'
require 'test_notifier/runner/minitest'
require "capybara/rails"

TestNotifier.silence_no_notifier_warning = true

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Support::Integration

  setup do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = {
      'provider'  => "github",
      'uid'       => '12345',
      'user_info' => { 'nickname' => 'frankpepelio' }
    }
  end
  teardown { Capybara.reset_sessions! }
end

OmniAuth.config.test_mode = true

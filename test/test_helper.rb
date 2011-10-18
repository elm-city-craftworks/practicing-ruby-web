ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/mini_contest'
require 'test_notifier/runner/minitest'
require "capybara/rails"

TestNotifier.silence_no_notifier_warning = true

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

OmniAuth.config.test_mode = true

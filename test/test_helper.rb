# require 'simplecov'
# SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
ENV["AUTH_MODE"] = "github"

require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'rails/test_help'
require_relative 'support/integration'
require_relative 'support/simulated_user'
require_relative 'support/outbox'
require_relative 'support/mini_contest'
require 'test_notifier/runner/minitest'
require 'capybara/rails'
require 'database_cleaner'
require 'capybara/poltergeist'
require 'minitest/autorun'

TestNotifier.silence_no_notifier_warning = true
DatabaseCleaner.strategy                 = :truncation
OmniAuth.config.test_mode                = true
Turn.config.natural                      = true
Capybara.javascript_driver               = :poltergeist
#Delayed::Worker.delay_jobs               = false

Capybara.register_driver :poltergeist do |app|
   Capybara::Poltergeist::Driver.new(app, {
     # For Stripe
     # https://github.com/teampoltergeist/poltergeist/issues/560
     phantomjs_options: ['--ssl-protocol=any']
   })
end

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

    ActionMailer::Base.deliveries.clear
  end

  teardown do
    # Clean up generated stripe customers
    #
    stripe_customers = User.where(%{payment_provider = 'stripe' and
                                    payment_provider_id is not null})
    stripe_customers.each do |user|
      payment_gateway = user.payment_gateway
      payment_gateway.customer.delete
    end

    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

def skip_unless_stripe_configured
  unless ENV["STRIPE_SECRET_KEY"].present?
    skip "Stripe not configured! Set STRIPE_SECRET_KEY and " +
         "STRIPE_PUBLISHABLE_KEY if you'd like to run this test."
  end
end

source 'https://rubygems.org'

gem 'rails', '3.2.22'
gem 'rake', '~> 0.9.0'
gem 'json', '~> 1.7.7'
gem 'multi_xml', '>= 0.5.2'

gem 'pg', '0.16.0'
gem 'mailchimp'
gem 'omniauth-oauth2', '~> 1.1.1'
gem 'omniauth-github', '~> 1.0.1'

gem 'redcarpet', "~> 3.1.0"
gem 'albino'
gem 'nokogiri', '~> 1.5.11'
gem 'md_preview'
gem 'md_emoji'

gem 'stripe'
gem 'stripe_event'

gem 'will_paginate', '>= 3.0.5'
gem 'haml'
gem 'coffee-filter', '~> 0.1.1'
gem 'jquery-rails', '~> 1.0.19'
gem 'draper'
gem 'rack-pjax', '~> 0.6.0'

gem 'httparty', '>= 0.10.0'

gem 'mailhopper', '~> 0.0.4'
gem 'delayed_mailhopper'
gem 'delayed_job', '~> 3.0.3'
gem 'delayed_job_active_record'
gem 'daemons', :require => false

gem 'whenever'
gem 'rails_setup'

gem 'mustache'

gem 'dotenv-rails'

gem 'pry-rails', groups: [:development, :test]

group :development do
  gem 'dotenv-deployment'
  gem 'capistrano'
  gem 'capistrano_confirm_branch'
  gem 'capistrano-unicorn', :require => false
  gem 'capistrano-maintenance'
  gem 'capfire'
  gem 'foreman'
  gem 'mailcatcher'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.0'
  gem 'coffee-rails', '~> 3.2.0'
  gem 'uglifier'
  gem 'compass-rails'
  gem 'sassy-buttons'
  gem 'turbo-sprockets-rails3'
  gem 'parsley-rails'
end

group :test do
  gem 'minitest'
  gem 'capybara', '=2.0.3'
  gem 'capybara-screenshot'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'mocha', :require => false
  gem 'database_cleaner'
  gem 'test_notifier'
  gem 'turn', '~> 0.9.5'
  gem 'simplecov', :require => false
  gem 'poltergeist'
  gem 'rubocop', '~> 0.18.1'
end

group :production do
  gem 'god', :require => false
  gem 'exception_notification', "~> 4.0.1"
  gem 'rack-google_analytics'
  gem 'unicorn'
end

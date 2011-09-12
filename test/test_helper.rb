ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/mini_contest'
require 'test_notifier/runner/minitest'


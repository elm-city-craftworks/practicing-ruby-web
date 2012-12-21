require 'fileutils'

namespace :travis do
  desc 'Create database.yml for testing'
  task :setup do

    Rake::Task["setup:initializers"].invoke

    # Setup our database.yml file
    #
    File.open(Rails.root.join("config", "database.yml"), 'w') do |f|
      f << <<-CONFIG
test:
  adapter: postgresql
  database: pr_test
  username: postgres
  min_messages: error
  encoding: utf8
CONFIG
    end

    # Create the database
    #
    `psql -c 'create database pr_test;' -U postgres`

    # Load the schema
    #
    Rake::Task["db:test:load"].invoke
  end
end
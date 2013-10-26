set :stages, %w(production old_production vagrant)
set :default_stage, "production"

require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano/confirm_branch'
require 'capistrano/maintenance'
require 'capistrano-unicorn'
require 'whenever/capistrano'
require "dotenv/capistrano"

set :application, "practicing-ruby"
set :repository,  "https://github.com/elm-city-craftworks/practicing-ruby-web.git"
set :scm, :git
set :branch, $1 if `git branch` =~ /\* (\S+)\s/m

set :use_sudo, false
set :deploy_via, :remote_cache

set :whenever_command, "bundle exec whenever"
set :whenever_identifier, defer { application }

set :maintenance_template_path, 'app/views/layouts/maintenance.html.erb'
set :maintenance_config_warning, false

after 'deploy:update_code' do
  { "database.yml"             => "config/database.yml",
    "mixpanel.rb"              => "config/initializers/mixpanel.rb"}.
  each do |from, to|
    run "ln -nfs #{shared_path}/#{from} #{release_path}/#{to}"
  end
end

after  "deploy", "deploy:migrate"
after  "deploy", "deploy:cleanup"

load 'deploy/assets'

before 'deploy:update_code' do
  run "sudo god stop practicing_ruby_delayed_job"
end

after 'deploy' do
  run  "sudo god load #{release_path}/config/delayed_job.god"
  run  "sudo god start practicing_ruby_delayed_job"
  run_rake "bake:articles"
end

desc "Import articles, volumes, and collections from the server"
namespace :import do
  task :articles do
    file  = "#{application}.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.sql.bz2"
    remote_file = "#{current_path}/#{file}"
    remote_db   = remote_database_config

    run %{pg_dump --clean --no-owner --no-privileges -t articles -t volumes -t
    collections #{remote_db['database']} | bzip2 > #{remote_file}
    } do |ch, stream, out|
      ch.send_data "#{remote_db['password']}\n" if out =~ /^Password:/
      puts out
    end

    rsync = "rsync #{user}@#{find_servers.first.host}:#{remote_file} tmp"
    puts `#{rsync}`

    local_db = database_config

    load_articles = "bzcat tmp/#{file} | psql -U#{local_db['username']} #{local_db['database']}"
    puts `#{load_articles}`

    run "rm #{remote_file}"
    `rm tmp/#{file}`

    `rake tmp:cache:clear`

    puts "  * Articles, Volumes, and Collections Imported"
  end
end

def database_config(db="development")
  YAML::load_file('config/database.yml')[db]
end

def remote_database_config(db="production")
  remote_config = capture("cat #{shared_path}/database.yml")
  YAML::load(remote_config)[db]
end

def run_rake(cmd, options={}, &block)
  command = "cd #{current_release} && /usr/bin/env bundle exec rake #{cmd} RAILS_ENV=#{rails_env}"
  run(command, options, &block)
end

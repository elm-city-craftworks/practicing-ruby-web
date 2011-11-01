require 'bundler/capistrano'

set :application, "practicing-ruby-web"
set :repository,  "git://github.com/elm-city-craftworks/practicing-ruby-web.git"

set :scm, :git
set :deploy_to, "/var/rapp/#{application}"

set :user, "git"
set :use_sudo, false

set :deploy_via, :remote_cache

set :branch, "master"
server "practicingruby.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after 'deploy:update_code' do
  { "database.yml"          => "config/database.yml",
    "mail_settings.rb"      => "config/initializers/mail_settings.rb",
    "mailchimp_settings.rb" => "config/initializers/mailchimp_settings.rb",
    "omniauth.rb"           => "config/initializers/omniauth.rb" }.
  each do |from, to|
    run "ln -nfs #{shared_path}/#{from} #{release_path}/#{to}"
  end
end

before 'deploy' do
  puts "\n*** Capistrano not setup on server ***\n" +
       "***   Run webbynode push instead   ***\n\n"
  exit
end

after "deploy", "deploy:migrate"
after "deploy", 'deploy:cleanup'

# load 'deploy/assets' Asset Precompile
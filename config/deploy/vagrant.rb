#
# Capistrano config to deploy the Practicing Ruby app to a Vagrant VM that was
# provisioned with the Practicing Ruby Chef cookbook
#
# See https://github.com/elm-city-craftworks/practicing-ruby-cookbook#capistrano
#

set :deploy_to, "/home/deploy"
set :user, "deploy"

# Only production is supported at the moment
set :rails_env, "production"

# Use Ruby version installed by chruby
set :default_environment, { "PATH" => "/opt/rubies/2.0.0-p247/bin:$PATH" }

# Set custom hostname to connect to Vagrant VM
server "practicingruby.local", :app, :web, :db, :primary => true

desc "Import articles, volumes, and collections from the server"
namespace :import do
  task :articles do
    remote_db = remote_database_config
    file = "dump.sql.bz2"

    `rsync db/#{file} #{user}@#{find_servers.first.host}:/tmp/#{file}`

    run %{ bzcat /tmp/dump.sql.bz2 | } +
        %{PGPASSWORD=#{remote_db['password']} }  +
        %{psql -U#{remote_db['username']} -hlocalhost #{remote_db['database']}}
  end
end
   



after "deploy:restart", "unicorn:restart"

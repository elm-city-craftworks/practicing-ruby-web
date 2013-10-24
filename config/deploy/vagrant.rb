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

after "deploy:restart", "unicorn:restart"

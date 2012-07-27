set :branch, "redesign"
set :deploy_to, "/var/rapp/staging/#{application}"

server "staging.practicingruby.com", :app, :web, :db, :primary => true
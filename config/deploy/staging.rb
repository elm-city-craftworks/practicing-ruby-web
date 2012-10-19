set :branch, $1 if `git branch` =~ /\* (\S+)\s/m
set :deploy_to, "/var/rapp/staging/#{application}"

server "staging.practicingruby.com", :app, :web, :db, :primary => true
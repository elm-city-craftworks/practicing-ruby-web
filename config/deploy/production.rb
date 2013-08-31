set :deploy_to, "/home/deploy"
set :user, "deploy"

server "practicingruby.com", :app, :web, :db, :primary => true

after 'deploy:restart', 'unicorn:restart'

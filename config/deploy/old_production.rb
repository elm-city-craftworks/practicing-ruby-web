set :user, "git"
set :deploy_to, "/var/rapp/#{application}"

server "173.246.46.66", :app, :web, :db, :primary => true

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end


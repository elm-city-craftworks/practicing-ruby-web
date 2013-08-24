require 'whenever/capistrano'

set :whenever_identifier, defer { application }

set :deploy_to, "/home/deploy"
set :user, "deploy"

server "173.246.40.123", :app, :web, :db, :primary => true

before 'deploy:update_code' do
  #run "sudo god stop practicing_ruby_delayed_job"
end

after 'deploy' do
  #run  "sudo god load #{release_path}/config/delayed_job.god"
  #run  "sudo god start practicing_ruby_delayed_job"
  #run_rake "bake:articles"
end

after 'deploy:restart', 'unicorn:restart'

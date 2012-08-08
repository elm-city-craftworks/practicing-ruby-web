require 'whenever/capistrano'

set :whenever_identifier, defer { application }

set :branch, "redesign"
set :deploy_to, "/var/rapp/#{application}"

server "practicingruby.com", :app, :web, :db, :primary => true

before 'deploy:update_code' do
  run "sudo god stop practicing_ruby_delayed_job"
end

after 'deploy' do
  run  "sudo god load #{release_path}/config/delayed_job.god"
  run  "sudo god start practicing_ruby_delayed_job"
  run_rake "bake:articles"
end
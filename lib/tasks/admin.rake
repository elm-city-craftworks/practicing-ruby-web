ActiveRecord::Base.configurations = YAML.load_file(Rails.root.join('config/database.yml'))
ActiveRecord::Base.establish_connection Rails.env

require Rails.root.join('app/models/user')

namespace :admin do
  task :subscribers do
    User.select("status, count(*) as user_count").group("status").each do |g|
      puts "- #{g.status}: #{g.user_count}"
    end

    puts "Total: #{User.count}"
  end
end
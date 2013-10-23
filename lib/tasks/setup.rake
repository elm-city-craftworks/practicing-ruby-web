require 'rails_setup'

namespace :setup do
  desc 'Create initializers from example files'
  setup_task :initializers do
    initializers_dir = Rails.root.join('config', 'initializers')
    secret_token     = initializers_dir.join('secret_token.rb').to_s

    unless File.exists?(secret_token)
      secret   = SecureRandom.hex(64)
      template = ERB.new(File.read(secret_token + '.example'))

      File.open(secret_token, 'w') {|f| f.write(template.result(binding)) }
    end

    done "secret_token.rb"
    
    initializers = %w[stripe.rb omniauth.rb mailchimp_settings.rb 
                      cache_cooker_settings.rb domain_settings.rb mixpanel.rb]
                      
    initializers.map! {|f| initializers_dir.join(f) }
    
    initializers.each do |file|
      name = file.basename.to_s
      find_or_create_file(file.to_s, name)
      done name
    end

    find_or_create_file("#{Rails.root}/.env", ".env")
    done(".env")
  end
end

desc 'Setup Practicing Ruby for development'
setup_task :setup do

  puts # Empty Line
  puts "#{heart} You are awesome #{heart}"

  section "Configuration Files" do
    database = Rails.root.join('config', 'database.yml').to_s
    
    find_or_create_file(database, "Database config", true)
    done "database.yml"

    Rake::Task["setup:initializers"].invoke
  end

  section "Database" do
    begin
      # Check if there are pending migrations
      silence { Rake::Task["db:abort_if_pending_migrations"].invoke }
      done "Skip: Database already setup"
    rescue Exception
      silence do
        Rake::Task["db:create"].invoke
        Rake::Task["db:schema:load"].invoke
      end
      done "Database setup"
    end
  end
  
  section "Dependencies" do
    `easy_install Pygments`
    
    done "Pygments installed"
  end

  puts # Empty Line
  puts %{#{'===='.color(:green)} Setup Complete #{'===='.color(:green)}}
  puts # Empty Line

  if console.agree("Would you like to run the test suite? (y/n)")
    silence { Rake::Task["db:test:load"].invoke }
    ENV["TRAVIS"] = 'TRUE' # Skip tests that won't run on travis
    Rake::Task["test"].invoke
  end

end

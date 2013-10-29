namespace :import do
  task :articles do
    sh %{ bzcat db/dump.sql.bz2 | #{psql}}
  end

  def psql(env=Rails.env.to_s)
    config = YAML.load_file("config/database.yml")[env]

    command = 'psql'

    if config['password']
      command = "PGPASSWORD=#{config['password']} #{command}"
    end

    if config['username']
      command = "#{command} -U#{config['username']}"
    end

    "#{command} -h#{config['host'] || 'localhost'} #{config['database']}"
  end
end

namespace :import do
  task :articles do
    sh %{ bzcat db/dump.sql.bz2 | #{psql}}
  end

  def psql(env="development")
    config = YAML.load_file("config/database.yml")[env]

    command = 'psql'

    if config['password']
      command = "PGPASSWORD=#{config['password']} #{command}"
    end

    if config['user']
      command = "#{command} -U#{config['username']}"
    end

    "#{command} -hlocalhost #{config['database']}"
  end
end

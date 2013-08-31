rails_root = File.dirname(File.dirname(__FILE__))

God.watch do |w|
  script          = "#{rails_root}/script/delayed_job"
  w.name          = "practicing_ruby_delayed_job"
  w.group         = "practicing_ruby"
  w.interval      = 60.seconds
  w.start         = "#{script} -n 4 start"
  w.restart       = "#{script} -n 4 restart"
  w.stop          = "#{script} stop"
  w.start_grace   = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file      = "#{rails_root}/tmp/pids/delayed_job.pid"
  w.log           = "#{rails_root}/log/delayed_job.god.log"
  w.err_log       = "#{rails_root}/log/delayed_job.god.errors.log"

  w.env = { 'RAILS_ENV' => "production" }

  w.behavior(:clean_pid_file)

  # retart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 300.megabytes
      c.times = 2
      c.notify = 'jordan'
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
      c.notify   = 'jordan'
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end

  # notify if process exists
  w.transition(:up, :start) do |on|
    on.condition(:process_exits) { |c| c.notify = 'jordan' }
  end
end

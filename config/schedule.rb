set :output, "~/practicing-ruby/current/log/cron_log.log"

# Make sure +bundle exec+ is used when executing rake tasks
#
job_type :rake, "cd :path && RAILS_ENV=:environment bundle exec rake :task --silent :output"

every 10.minutes do
  rake "mailchimp:disable_unsubscribed"
end

every 1.month do
  rake "stripe:card_exipration_notice"
end
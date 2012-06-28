set :output, "~/practicing-ruby/current/log/cron_log.log"

every 10.minutes do
  rake "mailchimp:disable_unsubscribed"
end

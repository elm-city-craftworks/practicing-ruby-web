set :output, "~/practicing-ruby/current/log/cron_log.log"

every 1.hour do
  rake "mailchimp:update_subscribers"
end

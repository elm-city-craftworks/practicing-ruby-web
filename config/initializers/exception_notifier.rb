if Rails.env.production?
  PracticingRubyWeb::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Practicing Ruby] ",
    :sender_address => %{"Practicing Ruby" <notifier@practicingruby.com>},
    :exception_recipients => %w{gregory.t.brown@gmail.com}
end

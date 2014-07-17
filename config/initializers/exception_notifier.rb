if Rails.env.production?
  PracticingRubyWeb::Application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[Practicing Ruby] ",
      :sender_address => %{"Exception Notifier" <gregory@practicingruby.com>},
      :exception_recipients => %w{gregory.t.brown@gmail.com jordan.byron@gmail.com}
     },
    :ignore_crawlers => %w{EasouSpider},
    :ignore_exceptions    => [ActionView::MissingTemplate] + ExceptionNotifier.ignored_exceptions
end

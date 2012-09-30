if Rails.env.production?
  PracticingRubyWeb::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Practicing Ruby] ",
    :exception_recipients => %w{gregory.t.brown@gmail.com jordan.byron@gmail.com},
    :ignore_exceptions    => ['ActionView::MissingTemplate'] + ExceptionNotifier.default_ignore_exceptions
end

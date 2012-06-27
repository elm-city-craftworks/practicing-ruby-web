module RakeExceptionNotification
  # Exception notification (rails3) only works as a rack middleware,
  # but what if you need notifications inside a rake task or a script?
  # This is a quick hack around that.
  #
  # Source: https://gist.github.com/551136
  #
  # Wrap your code inside an exception_notify block and you will be notified of exceptions
  #
  # exception_notify { # Dangerous Code Here }
  def exception_notify
    yield
  rescue Exception => exception
    if Rails.env.production?
      env = {}
      env['exception_notifier.options'] = {
        # TODO: DRY this configuration up
        :email_prefix => '[Practicing Ruby Rake] ',
        :exception_recipients => %w{gregory.t.brown@gmail.com jordan.byron@gmail.com},
        :sections => ['backtrace']
      }
      ExceptionNotifier::Notifier.exception_notification(env, exception).deliver
    end
    raise exception
  end
end
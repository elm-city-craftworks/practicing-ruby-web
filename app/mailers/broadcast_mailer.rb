class BroadcastMailer < ActionMailer::Base
  def deliver_broadcast(message={})
    @body = message[:body]

    user_batches(message) do |users|
      mail(
        :to      => "gregory@practicingruby.com",
        :bcc     => users,
        :subject => message[:subject]
      ).deliver
    end
  end

  private

  def user_batches(message)
    yield(message[:to]) && return if message[:commit] == "Test"

    User.where(:notify_updates => true).to_notify.
      find_in_batches(:batch_size => 25) do |group|
        yield group.map(&:contact_email)
    end
  end
end

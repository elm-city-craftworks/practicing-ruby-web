class ConversationMailer < ActionMailer::Base
  def started(article, users)
    @article = article

    batch(users) do |addresses|
      mail(
        :to      => "gregory@practicingruby.com",
        :bcc     => addresses,
        :subject => "Conversation has started on '#{@article.subject}'"
      ).deliver
    end
  end

  def mentioned(comment, users)
    @article = comment.commentable

    batch(users) do |addresses|
      mail(
        :to      => "gregory@practicingruby.com",
        :bcc     => addresses,
        :subject => "Someone mentioned you in '#{@article.subject}'"
      ).deliver
    end
  end

  def comment_made(comment, users)
    @article = comment.commentable

    batch(users) do |addresses|
      mail(
        :to      => "gregory@practicingruby.com",
        :bcc     => addresses,
        :subject => "A comment was added to '#{@article.subject}'"
      ).deliver
    end
  end

  private

  def batch(users)
    users.to_notify.find_in_batches(:batch_size => 25) do |group|
      yield group.map(&:contact_email)
    end
  end
end

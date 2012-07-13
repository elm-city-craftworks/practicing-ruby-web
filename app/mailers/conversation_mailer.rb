class ConversationMailer < ActionMailer::Base
  def started(article, users)
    @article = article

    batch(users) do |addresses|
      mail(
        :to      => "gregory@practicingruby.com",
        :bcc     => addresses,
        :subject => "A conversation has started about Practicing Ruby #{article.issue_number}"
      ).deliver
    end
  end

  def mentioned(comment, users)
    @article = comment.commentable

    batch(users) do |addresses|
      mail(
        :to      => "gregory@practicingruby.com",
        :bcc     => addresses,
        :subject => "You've been mentioned in a conversation about Practicing Ruby #{@article.issue_number}"
      ).deliver
    end
  end

  def comment_made(comment, users)
    @article = comment.commentable

    batch(users) do |addresses|
      mail(
        :to      => "gregory@practicingruby.com",
        :bcc     => addresses,
        :subject => "A comment has been made about Practicing Ruby #{@article.issue_number}"
      ).deliver
    end
  end

  private

  def batch(users)
    users.to_notify.find_in_batches(:batch_size => 25) do |group|
      yield group.map(&:email)
    end
  end
end

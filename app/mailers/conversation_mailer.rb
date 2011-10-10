class ConversationMailer < ActionMailer::Base
  default :from => "practicingruby@gmail.com"

  def started(article, users)
    @article = article

    mail(
      :to      => "practicingruby@gmail.com",
      :bcc     => users,
      :subject => "A conversation has started about Practicing Ruby #{article.issue_number}"
    )
  end

  def mentioned(comment, users)
    @article = comment.commentable

    mail(
      :to      => "practicingruby@gmail.com",
      :bcc     => users,
      :subject => "You've been mentioned in a conversation about Practicing Ruby #{@article.issue_number}"
    )
  end

  def comment_made(comment, users)
    @article = comment.commentable

    mail(
      :to      => "practicingruby@gmail.com",
      :bcc     => users,
      :subject => "A comment has been made about Practicing Ruby #{@article.issue_number}"
    )
  end
end

class ConversationMailer < ActionMailer::Base
  default :from => "practicingruby@gmail.com"

  def started(article)
    @article = article
    users = User.where(:notify_conversations => true).map {|u| u.email }

    mail(
      :to      => "practicingruby@gmail.com",
      :bcc     => users,
      :subject => "A conversation has started about Practicing Ruby #{article.issue_number}"
    )
  end

  def mentioned(comment)
    @article = comment.commentable
    users = comment.mentioned_users.where(:notify_mentions => true).map {|u| u.email }

    return if users.empty?

    mail(
      :to      => "practicingruby@gmail.com",
      :bcc     => users,
      :subject => "You've been mentioned in a conversation about Practicing Ruby #{@article.issue_number}"
    )
  end
end

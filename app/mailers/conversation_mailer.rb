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

  end
end

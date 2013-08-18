class ConversationNotifier
  def self.broadcast(comment)
    new(comment).broadcast
  end

  def initialize(comment)
    self.comment     = comment
    self.author      = comment.user
    self.article     = comment.commentable
  end

  def broadcast
    return unless article.published?

    if comment.first_comment?
      ConversationMailer.started(article, conversation_watchers)
    else
      ConversationMailer.comment_made(comment, comment_watchers) 
    end

    ConversationMailer.mentioned(comment, mentioned_watchers)
  end

  private

  attr_accessor :comment, :author, :article

  def comment_watchers
    users.where(:notify_comment_made => true)
  end

  def conversation_watchers
    users.where(:notify_conversations => true)
  end

  def mentioned_watchers
    comment.mentioned_users.where(:notify_mentions => true)
  end

  def users
    relation = User.where("id != ?", author.id)

    if mentioned_watchers.any?
      relation.where("users.id NOT IN(?)", mentioned_watchers)
    else
      relation
    end
  end
end

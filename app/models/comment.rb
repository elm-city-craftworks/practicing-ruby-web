class Comment < ActiveRecord::Base
  after_create :notify_conversation_started, :notify_mentioned,
               :notify_comment_made

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates_presence_of :body

  def mentioned_users
    mentions = body.scan(/@([a-z\d-]+)/i).flatten.map {|m| m.downcase }

    User.where("LOWER(github_nickname) IN (?)", mentions)
  end

  def editable_by?(user)
    self.user == user || user.admin?
  end

  def first_comment?
    commentable.comments.count == 1
  end

  private

  def notify_conversation_started
    if first_comment? && commentable.published?
      users = User.where(:notify_conversations => true)
      ConversationMailer.started(commentable, users)
    end
  end

  def notify_mentioned
    users = mentioned_users.where(:notify_mentions => true)

    return if users.empty? || !commentable.published?
    ConversationMailer.mentioned(self, users)
  end

  def notify_comment_made
    users = User.where(:notify_comment_made => true)
    users = users.where("users.id NOT IN(?)", mentioned_users) if mentioned_users.any?

    return if users.empty? || first_comment? || !commentable.published?
    ConversationMailer.comment_made(self, users)
  end

end

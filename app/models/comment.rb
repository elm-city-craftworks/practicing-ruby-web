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
    if first_comment?
      users = User.where(:notify_conversations => true).map {|u| u.email }
      users.each_slice(25) do |u|
        ConversationMailer.started(commentable, u).deliver
      end
    end
  end

  def notify_mentioned
    users = mentioned_users.where(:notify_mentions => true).map {|u| u.email }

    return if users.empty?
    ConversationMailer.mentioned(self, users).deliver
  end

  def notify_comment_made
    users = User.where(:admin => true)
    users = users.where("users.id NOT IN(?)", mentioned_users) if mentioned_users.any?
    users = users.map {|u| u.email }

    return if users.empty? || first_comment?
    ConversationMailer.comment_made(self, users).deliver
  end

end

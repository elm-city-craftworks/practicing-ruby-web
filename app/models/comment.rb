class Comment < ActiveRecord::Base
  after_create :notify_conversation_started
  after_create :notify_mentioned

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates_presence_of :body

  def mentioned_users
    mentions = body.scan(/@(\S+)/).flatten.map {|m| m.downcase }

    User.where("LOWER(github_nickname) IN (?)", mentions)
  end

  private

  def notify_conversation_started
    if commentable.comments.count == 1
      users = User.where(:notify_conversations => true).map {|u| u.email }
      users.each_slice(25) do |u|
        ConversationMailer.started(commentable, u).deliver
      end
    end
  end

  def notify_mentioned
    ConversationMailer.mentioned(self).deliver
  end

end

class Comment < ActiveRecord::Base
  after_create { |comment| ConversationNotifier.broadcast(comment) }

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
end

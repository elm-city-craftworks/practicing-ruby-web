class Article < ActiveRecord::Base
  has_many :comments, :as => :commentable

  validates_presence_of :issue_number

  scope :published, where(:status => "published")

  def self.published
    where(:status => "published")
  end

  def self.drafts
    where(:status => "draft")
  end

  def full_subject
    "Issue #{issue_number}: #{subject}"
  end

  def published?
    status == "published"
  end
end

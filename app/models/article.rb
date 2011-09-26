class Article < ActiveRecord::Base
  has_many :comments, :as => :commentable

  validates_presence_of :issue_number

  scope :published, where(:status => "published")

  def full_subject
    "Issue #{issue_number}: #{subject}"
  end
end

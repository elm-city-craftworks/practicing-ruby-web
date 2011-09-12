class Article < ActiveRecord::Base
  has_many :comments, :as => :commentable

  validates_presence_of :issue_number
end

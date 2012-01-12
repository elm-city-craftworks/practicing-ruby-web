class ArticleVisit < ActiveRecord::Base
  belongs_to :user
  belongs_to :article

  def viewed
    update_attribute(:views, views + 1)
  end
end

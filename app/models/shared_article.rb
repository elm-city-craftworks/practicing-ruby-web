class SharedArticle < ActiveRecord::Base
  before_create do
    write_attribute(:secret, SecretGenerator.generate(12))
    write_attribute(:views, 0)
  end

  belongs_to :user
  belongs_to :article

  def viewed
    update_attribute(:views, views + 1)
  end
end

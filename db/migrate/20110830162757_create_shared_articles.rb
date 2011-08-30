class CreateSharedArticles < ActiveRecord::Migration
  def self.up
    create_table :shared_articles do |t|
      t.belongs_to :user
      t.belongs_to :article
      t.text       :secret
      t.integer    :views

      t.timestamps
    end
  end

  def self.down
    drop_table :shared_articles
  end
end

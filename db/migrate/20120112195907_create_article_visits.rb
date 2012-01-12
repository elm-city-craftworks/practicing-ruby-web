class CreateArticleVisits < ActiveRecord::Migration
  def change
    create_table :article_visits do |t|
      t.belongs_to :user
      t.belongs_to :article
      t.integer    :views,   :default => 1

      t.timestamps
    end
  end
end

class AddCollectionIdToArticles < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.belongs_to :collection
    end
  end
end

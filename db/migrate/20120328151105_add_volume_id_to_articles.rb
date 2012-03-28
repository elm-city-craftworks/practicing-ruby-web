class AddVolumeIdToArticles < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.belongs_to :volume
    end
  end
end

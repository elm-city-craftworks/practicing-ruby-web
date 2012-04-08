class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :id
      t.string  :name
      t.text    :description
      t.string  :image_file_name
      t.string  :slug
      t.timestamps
    end
  end
end

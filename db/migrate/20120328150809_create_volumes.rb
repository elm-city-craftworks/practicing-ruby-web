class CreateVolumes < ActiveRecord::Migration
  def change
    create_table :volumes do |t|
      t.integer :number
      t.text    :description
      t.date    :start_date
      t.date    :finish_date
      t.timestamps
    end
  end
end

class AddShareTokenToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :share_token
    end
  end
end

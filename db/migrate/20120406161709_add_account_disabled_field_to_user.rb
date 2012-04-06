class AddAccountDisabledFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_disabled, :boolean, :default => false
  end
end

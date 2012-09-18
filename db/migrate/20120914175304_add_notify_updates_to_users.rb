class AddNotifyUpdatesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_updates, :boolean, :default => true, :null => false
  end
end

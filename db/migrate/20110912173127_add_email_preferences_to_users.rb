class AddEmailPreferencesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :notify_conversations, :boolean, :default => true, :null => false
    add_column :users, :notify_mentions,      :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :users, :notify_conversations
    remove_column :users, :notify_mentions
  end
end

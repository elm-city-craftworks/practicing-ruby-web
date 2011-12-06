class AddBroadcastColumnsToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :broadcast, :boolean, :default => false, :null => false
    add_column :announcements, :broadcast_message, :text
  end
end

class AddUrlToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :url, :string
  end
end

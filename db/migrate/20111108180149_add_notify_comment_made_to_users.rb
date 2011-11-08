class AddNotifyCommentMadeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_comment_made, :boolean, :default => false, :null => false
  end
end

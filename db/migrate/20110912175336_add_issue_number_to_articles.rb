class AddIssueNumberToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :issue_number, :text
  end

  def self.down
    remove_column :articles, :issue_number
  end
end

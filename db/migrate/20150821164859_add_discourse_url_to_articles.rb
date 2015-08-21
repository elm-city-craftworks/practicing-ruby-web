class AddDiscourseUrlToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :discourse_url, :string
  end
end

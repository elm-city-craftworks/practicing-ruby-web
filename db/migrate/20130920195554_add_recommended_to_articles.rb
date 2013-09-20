class AddRecommendedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :recommended, :boolean, :default => false, :null => false
  end
end

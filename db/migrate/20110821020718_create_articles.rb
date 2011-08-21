class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.text :subject
      t.text :body
      t.text :status, :default => "draft"
      t.text :mailchimp_campaign_id
      t.datetime :published_time

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end

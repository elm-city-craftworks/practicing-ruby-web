class CreateAuthorizationLinks < ActiveRecord::Migration
  def self.up
    create_table :authorization_links do |t|
      t.text :mailchimp_email
      t.text :github_nickname
      t.text :secret
      t.belongs_to :authorization
      t.timestamps
    end
  end

  def self.down
    drop_table :authorization_links
  end
end

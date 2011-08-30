class CreateAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :authorizations do |t|
      t.text :github_uid
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :authorizations
  end
end

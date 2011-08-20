class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.text :first_name
      t.text :last_name
      t.text :email
      t.text :mailchimp_web_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

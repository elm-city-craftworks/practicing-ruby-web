class AddGithubNicknameToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.text :github_nickname
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :github_nickname
    end
  end
end

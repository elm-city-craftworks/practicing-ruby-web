class AddBetaTesterFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :beta_tester, :boolean, :default => false
  end
end

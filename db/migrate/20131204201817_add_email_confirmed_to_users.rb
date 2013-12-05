class AddEmailConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_confirmed, :boolean, :default => false,
                                                   :null    => false
    execute %{update users set email_confirmed = true where status in
      ('active', 'confirmed', 'payment_pending')}
  end
end

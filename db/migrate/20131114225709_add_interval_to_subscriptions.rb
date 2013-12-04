class AddIntervalToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :interval, :string, default: 'month'
    rename_column :subscriptions, :monthly_rate_cents, :rate_cents
  end
end

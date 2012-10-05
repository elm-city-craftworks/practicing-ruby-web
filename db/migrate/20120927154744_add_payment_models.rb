class AddPaymentModels < ActiveRecord::Migration
  def up
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.date       :start_date, :null => false
      t.date       :finish_date
      t.text       :payment_provider
      t.integer    :monthly_rate_cents
    end

    create_table :payment_logs do |t|
      t.belongs_to :user
      t.text       :raw_data
    end

    add_column :users, :payment_provider,    :text
    add_column :users, :payment_provider_id, :text

    migrate_sql = %{UPDATE users
      SET   payment_provider    = 'mailchimp',
            payment_provider_id = users.mailchimp_web_id
      WHERE mailchimp_web_id IS NOT NULL }

    User.connection.execute(migrate_sql)

    remove_column :users, :mailchimp_web_id
  end

  def down
    drop_table :subscriptions
    drop_table :payment_logs

    add_column :users, :mailchimp_web_id, :text

    migrate_sql = %{UPDATE users
      SET   mailchimp_web_id = users.payment_provider_id
      WHERE payment_provider = 'mailchimp' }

    User.connection.execute(migrate_sql)

    remove_column :users, :payment_provider
    remove_column :users, :payment_provider_id
  end
end

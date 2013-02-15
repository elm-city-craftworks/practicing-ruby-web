class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :user
      t.date       :invoice_date
      t.decimal    :amount
      t.string     :stripe_invoice_id
      t.string     :credit_card_last_four
      t.boolean    :email_sent, :default => false, :null => false

      t.timestamps
    end
  end
end

class CreateCreditCards < ActiveRecord::Migration
  def up
    create_table :credit_cards do |t|
      t.belongs_to :user
      t.string     :last_four
      t.integer    :expiration_month
      t.integer    :expiration_year
      t.timestamps
    end
  end

  def down
    drop_table :credit_cards
  end
end

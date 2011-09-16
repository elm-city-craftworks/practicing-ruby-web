class ChangeMailColumnsToText < ActiveRecord::Migration
  COLUMNS = [ :to_address, :cc_address, :bcc_address, :reply_to_address,
              :subject ]

  def up
    COLUMNS.each do |column|
      change_column :emails, column, :text
    end
  end

  def down
    COLUMNS.each do |column|
      change_column :emails, column, :string
    end
  end
end

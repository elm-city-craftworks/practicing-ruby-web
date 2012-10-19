class CreditCard < ActiveRecord::Base
  belongs_to :user

  def description
    "XXXX-XXXX-XXXX-#{last_four} #{expiration_month}/#{expiration_year}"
  end
end
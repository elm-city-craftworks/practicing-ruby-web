class Authorization < ActiveRecord::Base
  has_one    :authorization_link
  belongs_to :user

  def confirmed?
    !!user
  end
end

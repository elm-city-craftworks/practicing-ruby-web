class Subscription < ActiveRecord::Base
  belongs_to :user

  scope :active, where(:finish_date => nil)
end
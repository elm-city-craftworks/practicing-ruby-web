class Subscription < ActiveRecord::Base
  belongs_to :user

  def self.active
    where(:finish_date => nil).first
  end

  def self.cancel_account
    active.update_attributes(:finish_date => Date.today) if active
  end
end
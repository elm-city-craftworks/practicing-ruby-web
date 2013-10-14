class Subscription < ActiveRecord::Base
  belongs_to :user

  after_save do
    Tracker.update_payment_provider(user)
  end

  def self.active
    where(:finish_date => nil).first
  end

  def self.cancel_account
    active.update_attributes(:finish_date => Date.today) if active
  end

  def active?
    finish_date.blank?
  end
end

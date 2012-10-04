class Subscription < ActiveRecord::Base
  belongs_to :user

  def self.active
    where(:finish_date => nil).first
  end
end
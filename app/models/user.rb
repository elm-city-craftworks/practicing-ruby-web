class User < ActiveRecord::Base
  has_many :comments

  validates_presence_of   :mailchimp_web_id, :email
  validates_uniqueness_of :mailchimp_web_id, :email

  attr_protected :admin

  def name
    "#{first_name} #{last_name}"
  end
end

class User < ActiveRecord::Base
  has_many :comments

  validates_presence_of   :mailchimp_web_id, :email
  validates_uniqueness_of :mailchimp_web_id, :email

  attr_protected :admin

  scope :to_notify, where(notifications_enabled: true)

  before_save do
    write_attribute(:email, email.downcase) if changed.include?("email")
  end

  def name
    "#{first_name} #{last_name}"
  end
end

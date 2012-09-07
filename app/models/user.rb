class User < ActiveRecord::Base
  has_many :comments

  validates_presence_of   :mailchimp_web_id, :email
  validates_uniqueness_of :mailchimp_web_id, :email

  validates_presence_of   :contact_email, :on => :update
  validates_uniqueness_of :contact_email, :on => :update

  attr_protected :admin, :status

  scope :to_notify, where(notifications_enabled: true)

  before_save do
    write_attribute(:email, email.downcase) if changed.include?("email")
  end

  def name
    "#{first_name} #{last_name}"
  end

  def disable
    update_attributes(:account_disabled => true,
      :notifications_enabled => false)
  end

  def enable(mailchimp_web_id)
    update_attributes(:account_disabled      => false,
                      :notifications_enabled => true,
                      :mailchimp_web_id      => mailchimp_web_id)
  end

  def enable_notifications
    unless account_disabled || notifications_enabled
      update_attributes(:notifications_enabled => true)
    end
  end

  def create_access_token
    update_attribute(:access_token, SecureRandom.hex(10))
    access_token
  end

  def clear_access_token
    update_attribute(:access_token, nil)
  end
end

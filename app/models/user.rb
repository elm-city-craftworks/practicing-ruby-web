class User < ActiveRecord::Base
  STATUSES        = %w{authorized pending_confirmation confirmed payment_pending
                       active disabled}
  ACTIVE_STATUSES = %w{active}

  before_save :send_confirmation_email
  before_create do
    write_attribute(:share_token, SecureRandom.hex(5))
  end

  has_many :comments
  has_many :subscriptions
  has_many :payment_logs
  has_many :payments

  has_one :credit_card

  validates_uniqueness_of :contact_email, :on => :update
  validates :status,      :inclusion => {
    :in => STATUSES, :message => "%{value} is not a valid status" }

  # Email sanity check from Rails Docs
  # http://ar.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html#M000087
  #
  validates_format_of :contact_email,
    :with => /\A\s*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*\Z/i,
    :on   => :update

  attr_protected :admin, :status

  def self.to_notify
    where(:notifications_enabled => true,
          :status                => ACTIVE_STATUSES,
          :email_confirmed       => true)
  end

  def hashed_id
    Digest::SHA256.hexdigest(github_nickname)
  end

  def active?
    ACTIVE_STATUSES.include? status
  end

  def disabled?
    status == 'disabled'
  end

  def payment_gateway
    PaymentGateway.for_user(self)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def disable
    self.notifications_enabled = false
    self.status                = 'disabled'

    subscriptions.cancel_account

    save
  end

  def enable(mailchimp_web_id=nil)
    # TODO Move this to PaymentGateway
    unless mailchimp_web_id.blank?
      self.payment_provider_id = mailchimp_web_id
      self.payment_provider    = "mailchimp"
    end

    self.status                = 'active'
    self.notifications_enabled = true

    save
  end

  def enable_notifications
    unless disabled? || notifications_enabled
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

  private

  def send_confirmation_email
    if send_confirmation_email?
      write_attribute(:email_confirmed, false)
      if contact_email.present?
        write_attribute(:contact_email, contact_email.strip.downcase)
        write_attribute(:access_token, SecureRandom.hex(10))
        RegistrationMailer.email_confirmation(self).deliver
      end
    end
  end

  # Only send the confirmation email if the user's record is valid
  # and their account is active
  def send_confirmation_email?
    (changed.include?("contact_email") || changed.include?("status")) &&
    active?
  end
end

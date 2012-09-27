class User < ActiveRecord::Base
  STATUSES        = %w{authorized pending_confirmation confirmed payment_pending
                       active disabled}
  ACTIVE_STATUSES = %w{active payment_pending}

  has_many :comments
  has_many :subscriptions
  has_many :payment_logs

  validates_presence_of   :contact_email, :on => :update
  validates_uniqueness_of :contact_email, :on => :update, :allow_blank => true
  validates :status,      :inclusion => {
    :in => STATUSES, :message => "%{value} is not a valid status" }

  attr_protected :admin, :status

  scope :to_notify, where(notifications_enabled: true,
    :status => ACTIVE_STATUSES)

  before_save do
    write_attribute(:email, email.downcase) if changed.include?("email")
  end

  def active?
    ACTIVE_STATUSES.include? status
  end

  def disabled?
    status == 'disabled'
  end

  def name
    "#{first_name} #{last_name}"
  end

  def disable
    self.notifications_enabled = false
    self.status                = 'disabled'

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
end

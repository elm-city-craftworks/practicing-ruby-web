class << (Tracker = Object.new)
  def update_status(user)
    mixpanel.set(user.hashed_id, :status => user.status)
  end

  def update_payment_provider(user)
    if s = user.subscriptions.active
      mixpanel.set(user.hashed_id, :payment_provider => s.payment_provider) 
    else
      mixpanel.set(user.hashed_id, :payment_provider => nil)
    end
  end

  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new(MIXPANEL_API_TOKEN)
  end
end

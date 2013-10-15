class Tracker
  class << self
    def update_creation_date(user)
      tracker = new(user)

      tracker.set(:created_at => tracker.formatted_time(user.created_at))
    end

    def update_status(user)
      tracker = new(user)
      
      tracker.set(:status => user.status)
    end

    def update_payment_provider(user)
      tracker = new(user)

      if s = user.subscriptions.active
        tracker.set(:payment_provider => s.payment_provider) 
      else
        tracker.set(:payment_provider => nil)
      end
    end
  end

  def initialize(user, params={})
    @user     = user
    @mixpanel = Mixpanel::Tracker.new(MIXPANEL_API_TOKEN, params)
  end

  def track(event, params={})
    if @user.try(:github_nickname)
      params = { :distinct_id => @user.hashed_id }.merge(params)
    end

    @mixpanel.track(event, params)

    update_timestamp
  end

  def set(params)
    return unless @user.try(:github_nickname)

    @mixpanel.set(@user.hashed_id, params)
  end

  def update_timestamp
    set("$last_seen" => formatted_time(Time.now))
  end

  def formatted_time(time)
    time.utc.strftime("%Y-%m-%dT%H:%M:%S")
  end
end

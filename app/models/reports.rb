class << (Reports = Object.new)
  def payment_provider_counts
    Subscription.select("payment_provider, count(*) as user_count")
                                  .where("finish_date is null")
                                  .group("payment_provider")
  end

  def paid_subscriber_count
    Subscription.where("finish_date is null and payment_provider <> 'free'").count
  end
  
  def recent_signups
    Subscription.includes("user")
                .where("finish_date is null and payment_provider <> 'free' and start_date > ?", Date.today-7)
                .map { |e| "#{e.user.contact_email} (#{e.user.github_nickname})" }
  end

  def recent_cancellations
    Subscription.includes("user")
                .where("finish_date > ? and payment_provider <> 'free'", Date.today-7)
                .map { |e| "#{e.user.contact_email} (#{e.user.github_nickname})" }
  end


end

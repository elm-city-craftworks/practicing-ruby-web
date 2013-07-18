class << (Reports = Object.new)
  def payment_provider_counts
    Subscription.select("payment_provider, count(*) as user_count")
                                  .where("finish_date is null")
                                  .group("payment_provider")
  end

  def paid_subscriber_count
    Subscription.where("finish_date is null and payment_provider <> 'free'").count
  end
  
  def activity
    query = %{ article_visits.updated_at > ? and 
               users.status = 'active' }

    report = {}
    
    [1,3,7,14,21,28].each do |days|
      date = Date.today - days
      
      q="start_date < :date and (finish_date is null or finish_date > :date)"

      subscribers = Subscription.where(q, :date => date).count.to_f

      report[days] = ArticleVisit.includes("user")
                                 .where(query, date)
                                 .group(:user_id).count.count / subscribers

    end

    report.map { |k,v| "#{k}: #{'%.2f' % v}" }.join(" | ")
  end

  def activation
    new_subscribers = User.where("created_at > ? and status = ?", 
                                 Date.today - 30, "active").to_a

    active_accounts = new_subscribers.select do |e| 
                        ArticleVisit.where(:user_id => e.id)
                                    .map { |e| e.created_at.to_date }.uniq.count > 1 
                      end

    percentage = "%.2f" % (active_accounts.count.to_f / new_subscribers.count)

    "#{active_accounts.count} / #{new_subscribers.count} ~= #{percentage}"
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

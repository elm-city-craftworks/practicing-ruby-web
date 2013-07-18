ActivationReport = ->() {
  new_subscribers = User.where("created_at > ? and status = ?", 
                               Date.today - 30, "active").to_a

  active_accounts = new_subscribers.select do |e| 
                      ArticleVisit.where(:user_id => e.id)
                                  .map { |e| e.created_at.to_date }.uniq.count > 1 
                    end

  percentage = "%.2f" % (active_accounts.count.to_f / new_subscribers.count)

  "#{active_accounts.count} / #{new_subscribers.count} ~= #{percentage}"
}


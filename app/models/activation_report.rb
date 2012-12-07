ActivationReport = ->() {
  new_subscribers = User.where("created_at > ? and status = ?", 
                               Date.today - 30, "active").to_a

  active_accounts = new_subscribers.select do |e| 
                      ArticleVisit.where(:user_id => e.id)
                                  .map { |e| e.created_at.to_date }.uniq.count > 2 
                    end

  percentage = "%.2f" % (active_accounts.count.to_f / new_subscribers.count)

  "Activation: #{active_accounts.count} / #{new_subscribers.count} ~= #{percentage}"
}


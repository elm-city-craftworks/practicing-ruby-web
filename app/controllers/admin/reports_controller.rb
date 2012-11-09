module Admin
  class ReportsController < ApplicationController
    before_filter :admin_only

    def index
      @statuses    = User.select("status, count(*) as user_count").group("status")
      @total_users = User.count
      @activity    = activity
    end

    private

    def activity
      query = %{ article_visits.updated_at > ? and 
                 users.status = 'active' }

      report = {}
      
      [7,14,21,28].each do |days|
        date = Date.today - days
        
        q="start_date < :date and (finish_date is null or finish_date > :date)"

        subscribers = Subscription.where(q, :date => date).count.to_f
 
        report[days] = ArticleVisit.includes("user")
                                   .where(query, date)
                                   .group(:user_id).count.count / subscribers

      end

      report.map { |k,v| "#{k}: #{'%.2f' % v}" }.join(" | ")
    end
  end
end

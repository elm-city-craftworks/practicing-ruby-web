module Admin
  class ReportsController < ApplicationController
    before_filter :admin_only

    def index 
      @statuses = Subscription.select("payment_provider, count(*) as user_count")
                              .where("finish_date is null")
                              .group("payment_provider")

      @total_users = Subscription.where("finish_date is null and payment_provider <> 'free'").count
      @activity    = ActivityReport.call
      @activation  = ActivationReport.call
    end
  end
end

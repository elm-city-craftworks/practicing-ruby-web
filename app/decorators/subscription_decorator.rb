class SubscriptionDecorator < ApplicationDecorator
  decorates :subscription

  def status
    if subscription.active?
      "Active"
    else
      "Canceled"
    end
  end

  def amount
    currency = h.number_to_currency(subscription.monthly_rate_cents / 100.0)

    "#{currency}/month"
  end
end
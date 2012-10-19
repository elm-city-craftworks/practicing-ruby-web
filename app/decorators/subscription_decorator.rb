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
    rate     = subscription.monthly_rate_cents || 0.0
    currency = h.number_to_currency(rate / 100.0)

    "#{currency}/month"
  end
end
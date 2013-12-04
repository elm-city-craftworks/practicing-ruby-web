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
    rate     = subscription.rate_cents || 0.0
    currency = h.number_to_currency(rate / 100.0)

    "#{currency}/#{interval}"
  end

  def change_billing_interval_message
    h.content_tag(:p) do
      %{You are about to change to a
        #{alternate_billing_interval}ly billing cycle.
        Since you have already paid for this #{subscription.interval}
        we will prorate your invoice to adjust for the time you've
        already paid for.}
    end +
    h.content_tag(:p) do
      action = (subscription.interval == "month" ? "charged" : "refunded")

      %{You will be #{action} after you click the button below and
        won't be charged again until #{Date.today + 1.year}.}
    end +
    h.content_tag(:p) do
      h.link_to "Change to #{alternate_billing_interval}ly billing",
        h.change_billing_interval_user_path(h.current_user,
          :interval => alternate_billing_interval),
        :class => 'btn', :method => 'post'
    end
  end

  def alternate_billing_interval
    case subscription.interval
    when 'month'
      'year'
    when 'year'
      'month'
    end
  end
end

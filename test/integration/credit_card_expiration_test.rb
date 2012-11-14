require 'test_helper'
require 'rake'

class CreditCardExpirationTest < ActionMailer::TestCase

  test "emails are sent to customers when their cards are about to expire" do
    date = Date.today.next_month

    card = FactoryGirl.create(:credit_card, :expiration_year  => date.year,
                                            :expiration_month => date.month)

    CardExpirer.call(date)

    message = ActionMailer::Base.deliveries.first

    assert message.to.include?(card.user.contact_email)
    assert message.body.to_s.include?(card.last_four)
  end

  test "emails are only sent for cards that expire next month" do
    this_month = Date.today
    FactoryGirl.create(:credit_card, :expiration_year  => this_month.year,
                                     :expiration_month => this_month.month )

    future_month = Date.today + 2.months
    FactoryGirl.create(:credit_card, :expiration_year  => future_month.year,
                                     :expiration_month => future_month.month )

    CardExpirer.call(Date.today.next_month)

    assert ActionMailer::Base.deliveries.empty?
  end
end
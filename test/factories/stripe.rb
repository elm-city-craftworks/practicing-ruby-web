require_relative '../support/stripe/invoice'

FactoryGirl.define do
  sequence (:stripe_customer_id) { |n| "cus_mock#{n}" }
  sequence (:stripe_invoice_id)  { |n| "in_mock#{n}" }

  factory 'support/stripe/invoice' do
    id            { FactoryGirl.generate :stripe_invoice_id  }
    customer      { FactoryGirl.generate :stripe_customer_id }
    period_start  Time.now.to_i
    date          Time.now.to_i
    total         100_00
    paid          true
    closed        false
  end
end
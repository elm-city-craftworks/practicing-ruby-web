FactoryGirl.define do
  factory :credit_card do |c|
    c.last_four("1234")
    c.expiration_month { Date.today.month }
    c.expiration_year  { Date.today.year  }
    c.user
  end
end

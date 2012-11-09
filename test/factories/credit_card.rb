FactoryGirl.define do
  sequence(:credit_card_number) { rand(1000..9999).to_s }

  factory :credit_card do |c|
    c.last_four        { FactoryGirl.generate(:credit_card_number) }
    c.expiration_month { Date.today.month }
    c.expiration_year  { Date.today.year  }
    c.user
  end
end

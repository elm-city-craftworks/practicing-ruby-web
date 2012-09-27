FactoryGirl.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  sequence(:payment_provider_id) { |n| "person_#{n}" }

  factory :user do |u|
    u.first_name            'Frank'
    u.last_name             'Pepelio'
    u.github_nickname       'frankpepelio'
    u.notifications_enabled  true
    u.email                  { FactoryGirl.generate(:email) }
    u.contact_email          { FactoryGirl.generate(:email) }
    u.payment_provider       'mailchimp'
    u.payment_provider_id    { FactoryGirl.generate(:payment_provider_id) }
    u.status                 'active'
  end
end

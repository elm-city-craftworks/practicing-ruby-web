FactoryGirl.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  sequence(:mailchimp_web_id) { |n| "person_#{n}" }

  factory :user do |u|
    u.first_name            'Frank'
    u.last_name             'Pepelio'
    u.github_nickname       'frankpepelio'
    u.notifications_enabled  true
    u.email                  { FactoryGirl.generate(:email) }
    u.contact_email          { email }
    u.mailchimp_web_id       { FactoryGirl.generate(:mailchimp_web_id) }
    u.status                 'active'
  end
end

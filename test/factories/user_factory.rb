Factory.sequence(:email) { |n| "person#{n}@example.com" }
Factory.sequence(:mailchimp_web_id) { |n| "person_#{n}" }

Factory.define :user do |u|
  u.first_name            'Frank'
  u.last_name             'Pepelio'
  u.github_nickname       'frankpepelio'
  u.notifications_enabled  true
  u.email                  { Factory.next(:email) }
  u.mailchimp_web_id       { Factory.next(:mailchimp_web_id) }
end

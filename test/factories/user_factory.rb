Factory.sequence(:email) { |n| "person#{n}@example.com" }
Factory.sequence(:mailchimp_web_id) { |n| "person_#{n}" }

Factory.define :user do |u|
  u.email                 { |_| Factory.next(:email) }
  u.first_name            'Frank'
  u.last_name             'Pepelio'
  u.github_nickname       'frankpepelio'
  u.mailchimp_web_id      { |_| Factory.next(:mailchimp_web_id) }
end

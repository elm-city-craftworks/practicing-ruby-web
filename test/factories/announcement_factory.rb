FactoryGirl.define do
  sequence(:announcement_title) { |n| "Announcement #{n}" }

  factory :announcement do |a|
    a.title             { |_| FactoryGirl.generate(:announcement_title) }
    a.body              "Announcement Body"
    a.broadcast_message { |announcement| announcement.title }
  end
end

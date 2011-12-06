Factory.sequence(:announcement_title) { |n| "Announcement #{n}" }

Factory.define :announcement do |a|
  a.title             { |_| Factory.next(:announcement_title) }
  a.body              "Announcement Body"
  a.broadcast_message { |announcement| announcement.title }
end

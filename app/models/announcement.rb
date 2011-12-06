class Announcement < ActiveRecord::Base
  belongs_to :author, :class_name => "User"

  scope :broadcasts, where(:broadcast => true)
end

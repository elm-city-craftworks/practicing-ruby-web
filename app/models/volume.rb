class Volume < ActiveRecord::Base
  has_many :articles
  
  def name
    "Volume #{number}"
  end
end

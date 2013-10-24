# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

def create_user(github_nickname)
  u = User.new(:github_nickname => github_nickname, 
               :contact_email => "#{github_nickname}@example.com")
  u.status = "active"

  yield u if block_given?

  u.save
  Authorization.create(:user_id => u.id, :github_uid => github_nickname)
end

# ------------------------------------------------------------------------------
# Create an admin user
# ------------------------------------------------------------------------------

create_user("admin") { |u| u.admin = true }

# ------------------------------------------------------------------------------
# Create several active accounts
# ------------------------------------------------------------------------------

%w[user1 user2 user3].each do |e|
  create_user(e)
end

# ------------------------------------------------------------------------------
# Create an account for each other account status
# ------------------------------------------------------------------------------

%w[authorized pending_confirmation confirmed disabled].each do |e|
  create_user(e) { |u| u.status = e }
end

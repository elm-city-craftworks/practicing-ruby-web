Factory.define :authorization do |a|
  a.github_uid(12345)
  a.association(:user, :factory => :user)
end

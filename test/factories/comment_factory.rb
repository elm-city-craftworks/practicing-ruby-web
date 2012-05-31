FactoryGirl.define do
  sequence(:comment_body) { |n| "Comment #{n}" }

  factory :comment do |c|
    c.body { |_| FactoryGirl.generate(:comment_body) }
    c.commentable { FactoryGirl.create(:article) }
    c.association :user
  end
end
Factory.sequence(:comment_body) { |n| "Comment #{n}" }

Factory.define :comment do |c|
  c.body { |_| Factory.next(:comment_body) }
  c.commentable { Factory(:article) }
  c.association :user
end
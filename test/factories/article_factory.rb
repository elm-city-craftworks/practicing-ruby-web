Factory.sequence(:article_subject) { |n| "Article #{n}" }

Factory.define :article do |a|
  a.subject       { |_| Factory.next(:article_subject) }
  a.body          "Article Body"
  a.issue_number  "Issue"
  a.status        "published"
end

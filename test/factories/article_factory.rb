FactoryGirl.define do
  sequence(:article_subject) { |n| "Article #{n}" }

  factory :article do |a|
    a.subject       { |_| FactoryGirl.generate(:article_subject) }
    a.body          "Article Body"
    a.issue_number  "1"
    a.status        "published"
  end
end

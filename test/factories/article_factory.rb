FactoryGirl.define do
  sequence(:article_subject) { |n| "Article #{n}" }

  factory :article do |a|
    a.subject       { |_| FactoryGirl.generate(:article_subject) }
    a.body          "Article Body"
    a.issue_number  "1"
    a.status        "published"
    a.volume
    a.published_time { Time.now }

    factory :public_article do
      status "public"
    end
  end

  sequence(:volume_number) { |n| n }

  factory :volume do |v|
    v.number { |_| FactoryGirl.generate(:volume_number) }
    v.description "The Best Volume Evar"
  end
end

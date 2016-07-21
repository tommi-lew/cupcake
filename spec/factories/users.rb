FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Baker #{n}" }
    sequence(:email) { |n| "baker#{n}@cupcake.world" }
    sequence(:pt_id) { |n| 1000000 + n }
    enabled true

    trait :with_personal_slack_webhook do
      sequence(:personal_slack_webhook) { |n| "personal_slack_webhook_#{n}" }
    end
  end
end

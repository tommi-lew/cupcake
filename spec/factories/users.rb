FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Baker #{n}" }
    sequence(:email) { |n| "baker#{n}@cupcake.world" }
    sequence(:pt_id) { |n| 1000000 + n }
  end
end

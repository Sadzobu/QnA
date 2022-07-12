FactoryBot.define do
  factory :vote do
    value { 1 }
    association :user
    association :voteable
  end

  trait :downvote do
    value { -1 }
  end
end

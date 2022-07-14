FactoryBot.define do
  factory :comment do
    body { 'MyComment' }
    association :user
    association :commentable
  end
end

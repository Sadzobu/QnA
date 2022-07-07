FactoryBot.define do
  factory :link do
    name { 'Google' }
    url { 'http://www.google.com' }
    association :linkable
  end
end

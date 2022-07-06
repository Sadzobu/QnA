FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "http://www.google.com" }
    association :linkable
  end
end

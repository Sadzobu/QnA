FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_attachment do
      after(:build) do |question|
        question.files.attach(
          io: File.open("#{Rails.root}/spec/rails_helper.rb"),
          filename: 'test.rb'
        )
      end
    end
  end
end

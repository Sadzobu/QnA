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

    trait :with_link do
      after(:build) do |question|
        create(:link, linkable: question)
      end
    end

    trait :with_reward do
      after(:build) do |question|
        create(:reward, question: question)
      end
    end
  end
end

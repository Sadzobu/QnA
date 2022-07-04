FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    trait :with_attachment do
      after(:build) do |answer|
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/rails_helper.rb"),
          filename: 'test.rb'
        )
      end
    end
  end
end

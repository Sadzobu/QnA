FactoryBot.define do
  factory :reward do
    title { 'MyReward' }
    association :question

    after :build do |reward|
      reward.file.attach(
        io: File.open("#{Rails.root}/spec/assets/reward.png"),
        filename: 'reward.png'
      )
    end
  end
end

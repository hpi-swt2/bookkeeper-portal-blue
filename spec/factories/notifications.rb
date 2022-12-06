FactoryBot.define do
  factory :notification do
    sequence(:date) { |n| "2022-11-0#{n} 13:47:20" }
    sequence(:active) { |n| n % 2 }
    user { FactoryBot.build(:user) }
  end
end

FactoryBot.define do
  factory :notification do
    sequence(:date) {Time.strptime("2022-11-0#{n} 13:47:20", "%Y-%m-%d %H:%M:%S")}
    sequence(:active) { |n| n % 2 }
    user { FactoryBot.build(:user) }
  end
end

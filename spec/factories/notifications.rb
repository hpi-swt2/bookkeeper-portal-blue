FactoryBot.define do
  factory :notification do
    sequence(:notification_snippet) {|n| "Notification #{n}" }
    sequence(:date) {|n| "2022-11-0#{n} 13:47:20" }
    user { FactoryBot.build(:user) }
  end
end

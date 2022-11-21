FactoryBot.define do
  factory :notification do
    notification_snippet { "MyString" }
    date { "2022-11-21 13:47:20" }
    user { FactoryBot.build(:user) }
  end
end

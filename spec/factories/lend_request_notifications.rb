FactoryBot.define do
  factory :lend_request_notification do
    sequence(:active) { |n| n % 2 }
    sequence(:date) { |n| Time.strptime("2022-11-0#{(n % 9) + 1} 13:47:20", "%Y-%m-%d %H:%M:%S") }
    sequence(:unread) { true }
    sequence(:accepted) { false }
    borrower { FactoryBot.build(:user) }
    receiver { FactoryBot.build(:user) }
    item { FactoryBot.build(:item) }
  end
end

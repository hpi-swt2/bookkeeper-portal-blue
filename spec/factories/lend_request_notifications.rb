FactoryBot.define do
  factory :lend_request_notification do
    sequence(:active) { |n| n % 2 }
    sequence(:date) {Time.now}
    sequence(:unread) { true }
    sequence(:accepted) { false }
    borrower { FactoryBot.build(:user) }
    user { FactoryBot.build(:user) }
    item { FactoryBot.build(:item) }
  end
end

FactoryBot.define do
  factory :lend_request_notification do
    borrower factory: :user
    item factory: :item_book
    user
    sequence(:date) { |n| "2022-11-0#{n} 13:47:20" }
    sequence(:active) { |n| n % 2 }
  end
end

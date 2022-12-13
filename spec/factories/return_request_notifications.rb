FactoryBot.define do
  factory :return_request_notification do
    active { true }
    unread { true }
    user { FactoryBot.build(:user) }
    date { Time.strptime("2022-11-01 13:47:20", "%Y-%m-%d %H:%M:%S") }
    item { FactoryBot.build(:pending, owner: user.id) }
    borrower { FactoryBot.build(:max) }
  end

  factory :invalid_return_request_notification, class: 'ReturnRequestNotification' do
    item { FactoryBot.build(:pending) }
    borrower { FactoryBot.build(:max) }
  end
end

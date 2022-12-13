FactoryBot.define do
  factory :return_request_notification do
    active {true}
    user { FactoryBot.build(:user) }
    date { Time.zone.now }
    item { FactoryBot.build(:pending, owner: user.id) }
    borrower { FactoryBot.build(:max) }
  end

  factory :invalid_return_request_notification, class: 'ReturnRequestNotification' do
    item { FactoryBot.build(:pending) }
    borrower { FactoryBot.build(:max) }
  end
end

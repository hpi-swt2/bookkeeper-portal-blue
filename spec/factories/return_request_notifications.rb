FactoryBot.define do
  factory :return_request_notification do
    receiver { FactoryBot.build(:user) }
    date { Time.zone.now }
    item { FactoryBot.build(:pending_return, owner: receiver.id, holder: receiver.id) }
    borrower { FactoryBot.build(:max) }
  end

  factory :invalid_return_request_notification, class: 'ReturnRequestNotification' do
    item { FactoryBot.build(:pending_return) }
    borrower { FactoryBot.build(:max) }
  end
end

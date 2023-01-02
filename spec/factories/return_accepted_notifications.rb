FactoryBot.define do
  factory :return_accepted_notification do
    user { FactoryBot.build(:user) }
    date { Time.zone.now }
    item { FactoryBot.build(:pending, owner: user.id) }
    borrower { FactoryBot.build(:max) }
  end

  factory :invalid_return_accepted_notification, class: 'ReturnAcceptedNotification' do
    item { FactoryBot.build(:pending) }
    borrower { FactoryBot.build(:max) }
  end
end
 
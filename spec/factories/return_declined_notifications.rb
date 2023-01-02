FactoryBot.define do
  factory :return_declined_notification do
    receiver { FactoryBot.build(:user) }
    date { Time.zone.now }
    item { FactoryBot.build(:lent, owner: receiver.id) }
    owner { FactoryBot.build(:max) }
  end

  factory :invalid_return_declined_notification, class: 'ReturnDeclinedNotification' do
    item { FactoryBot.build(:lent) }
    owner { FactoryBot.build(:max) }
  end
end

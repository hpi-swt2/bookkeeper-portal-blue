FactoryBot.define do
  factory :return_declined_notification do
    receiver { FactoryBot.build(:user) }
    date { Time.zone.now }
    item_name { FactoryBot.build(:lent, owner: receiver.id).name }
    owner { FactoryBot.build(:max) }
  end

  factory :invalid_return_declined_notification, class: 'ReturnDeclinedNotification' do
    item_name { FactoryBot.build(:lent).name }
    owner { FactoryBot.build(:max) }
  end
end

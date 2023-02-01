FactoryBot.define do
  factory :return_declined_notification do
    receiver { FactoryBot.build(:user) }
    date { Time.zone.now }
    item { FactoryBot.build(:lent, owning_user: receiver) }
  end

  factory :invalid_return_declined_notification, class: 'ReturnDeclinedNotification' do
    item_id { FactoryBot.build(:lent).name }
  end
end

FactoryBot.define do
  factory :return_accepted_notification do
    receiver { FactoryBot.build(:user) }
    date { Time.zone.now }
    item { FactoryBot.build(:pending_return, owning_user: receiver) }
  end

  factory :invalid_return_accepted_notification, class: 'ReturnAcceptedNotification' do
    item { FactoryBot.build(:pending_return) }
  end
end

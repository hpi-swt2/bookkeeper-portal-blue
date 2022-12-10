FactoryBot.define do
  factory :return_request_notification do
    user { FactoryBot.build(:user) }
    date { Time.now }
    item { FactoryBot.build(:pending, owner: user.id) }
    borrower { FactoryBot.build(:max) }
  end
end
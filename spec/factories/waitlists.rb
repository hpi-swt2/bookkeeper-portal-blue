FactoryBot.define do
  factory :waitlist do
    users { [ build(:user), build(:max) ] }
  end
  factory :waitlist_with_item, class: 'Waitlist' do
    users { [ build(:user), build(:max) ] }
    item { build(:item) }
  end
end

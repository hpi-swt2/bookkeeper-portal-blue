FactoryBot.define do
  factory :group do
    name { "TestGroup" }
    owners { [ FactoryBot.build(:user) ] }
  end
end

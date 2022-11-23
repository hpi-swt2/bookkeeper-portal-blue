FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
  factory :max, class: 'User' do
    email { "max.mustermann@student.hpi.uni-potsdam.de" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end

FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :max, class: 'User' do
    email { "max.mustermann@student.hpi.uni-potsdam.de" }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :peter, class: 'User' do
    email { "peter.lustig@hpi.de" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end

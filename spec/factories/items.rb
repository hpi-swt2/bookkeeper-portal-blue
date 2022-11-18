FactoryBot.define do
  factory :item do
    name { "MyString" }
    category { "MyString" }
    location { "MyString" }
    description { "MyText" }
    image { nil }
    price_ct { 1 }
    rental_duration_sec { 1 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "MyText" }
  end
end

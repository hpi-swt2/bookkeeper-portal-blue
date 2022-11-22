FactoryBot.define do
  factory :item do
    name { "MyName" }
    category { "MyCategory" }
    location { "MyLocation" }
    description { "MyDescription" }
    image { nil }
    price_ct { 1 }
    rental_duration_sec { 1 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "MyChecklist" }
  end
  factory :item_book, class: 'Item' do
    name { "Ruby on Rails by Example" }
    category { "Books" }
    location { "Epic Chair" }
    description { "Useful book for all who want to dive deeper" }
    image { nil }
    price_ct { 10_000 }
    rental_duration_sec { 60 * 60 * 24 * 7 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "Close the book. Remove sticky notes." }
  end
  factory :item_beamer, class: 'Item' do
    name { "Beamer" }
    category { "Equipment" }
    location { "Main building" }
    description { "Very small but powerful beamer to use during presentations. Also suitable for watching films." }
    image { nil }
    price_ct { 100 }
    rental_duration_sec { 60 * 60 * 3 }
    rental_start { "2022-11-21 15:32:07" }
    return_checklist { "Turn off the beamer." }
  end
  factory :item_whiteboard, class: 'Item' do
    name { "Whiteboard" }
    category { "Equipment" }
    location { "D-Space" }
    description { "Standard Whiteboard with lots of space for innovative ideas." }
    image { nil }
    price_ct { 500 }
    rental_duration_sec { 60 * 60 * 5 }
    rental_start { "2022-10-10 3:14:15" }
    return_checklist { "Clean the whiteboard." }
  end
end

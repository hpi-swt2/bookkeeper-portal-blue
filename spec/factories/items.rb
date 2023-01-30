FactoryBot.define do
  factory :item do
    name { "MyName" }
    type { "OtherItem" }
    location { "MyLocation" }
    description { "MyDescription" }
    image { Rack::Test::UploadedFile.new('spec/testimages/test_image.png', 'image/png') }
    price_ct { 1 }
    rental_duration_sec { 1 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "MyChecklist" }
    lend_status { :available }
    owning_user { create(:user) }
  end
  factory :item_owned_by_group, class: 'Item' do
    name { "MyName" }
    type { "OtherItem" }
    location { "MyLocation" }
    description { "MyDescription" }
    image { Rack::Test::UploadedFile.new('spec/testimages/test_image.png', 'image/png') }
    price_ct { 1 }
    rental_duration_sec { 1 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "MyChecklist" }
    lend_status { :available }
    owning_group { create(:group) }
  end
  factory :pending, class: 'Item' do
    name { "MyName2" }
    type { "OtherItem" }
    location { "MyLocation" }
    description { "MyDescription" }
    image { Rack::Test::UploadedFile.new('spec/testimages/test_image.png', 'image/png') }
    price_ct { 1 }
    rental_duration_sec { 1 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "MyChecklist" }
    lend_status { :pending_return }
    owning_user { create(:user) }
  end
  factory :lent, class: 'Item' do
    name { "MyName3" }
    category { "MyCategory" }
    type { "OtherItem" }
    location { "MyLocation" }
    description { "MyDescription" }
    image { Rack::Test::UploadedFile.new('spec/testimages/test_image.png', 'image/png') }
    price_ct { 1 }
    rental_duration_sec { 1 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "MyChecklist" }
    lend_status { :lent }
    owning_user { create(:user) }
    holder { owning_user.id }
  end
  factory :pending_return, class: 'Item' do
    name { "MyName3" }
    type { "OtherItem" }
    location { "MyLocation" }
    description { "MyDescription" }
    image { Rack::Test::UploadedFile.new('spec/testimages/test_image.png', 'image/png') }
    price_ct { 1 }
    rental_duration_sec { 1 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "MyChecklist" }
    lend_status { :pending_return }
    owning_user { create(:user) }
    holder { owning_user.id }
  end
  factory :item_book, class: 'Item' do
    name { "Ruby on Rails by Example" }
    type { "OtherItem" }
    location { "Epic Chair" }
    description { "Useful book for all who want to dive deeper" }
    image { nil }
    price_ct { 10_000 }
    rental_duration_sec { 60 * 60 * 24 * 7 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "Close the book. Remove sticky notes." }
    lend_status { :lent }
    owning_user { create(:user) }
  end
  factory :item_beamer, class: 'Item' do
    name { "Beamer" }
    type { "OtherItem" }
    location { "Main building" }
    description { "Very small but powerful beamer to use during presentations. Also suitable for watching films." }
    image { nil }
    price_ct { 100 }
    rental_duration_sec { 60 * 60 * 3 }
    rental_start { "2022-11-21 15:32:07" }
    return_checklist { "Turn off the beamer." }
    lend_status { :pending_return }
    owning_user { create(:user) }
  end
  factory :item_whiteboard, class: 'Item' do
    name { "Whiteboard" }
    location { "D-Space" }
    type { "OtherItem" }
    description { "Standard Whiteboard with lots of space for innovative ideas." }
    image { nil }
    price_ct { 500 }
    rental_duration_sec { 60 * 60 * 5 }
    rental_start { "2022-10-10 3:14:15" }
    return_checklist { "Clean the whiteboard." }
    owning_user { create(:user) }
  end

  factory :item_without_time, class: 'Item' do
    name { "Whiteboard" }
    type { "OtherItem" }
    location { "D-Space" }
    description { "Standard Whiteboard with lots of space for innovative ideas." }
    image { Rack::Test::UploadedFile.new('spec/testimages/test_image.png', 'image/png') }
    price_ct { 500 }
    rental_duration_sec { nil }
    rental_start { nil }
    return_checklist { "Clean the whiteboard." }
    owning_user { create(:user) }
  end

  factory :itemAudited0, class: 'Item' do
    id { 42_420 }
    name { "AuditedItem0" }
    type { "OtherItem" }
    location { "D-Space" }
    description { "An audited item" }
    image { nil }
    price_ct { 42 }
    rental_duration_sec { 42 }
    lend_status { :available }
    owning_user { create(:user) }
  end

  factory :itemAudited1, class: 'Item' do
    id { 42_421 }
    name { "AuditedItem1" }
    type { "OtherItem" }
    location { "D-Space" }
    description { "An audited item" }
    image { nil }
    price_ct { 42 }
    rental_duration_sec { 42 }
    lend_status { :available }
    owning_user { create(:user) }
  end

  factory :itemAudited2, class: 'Item' do
    id { 42_422 }
    name { "AuditedItem2" }
    type { "OtherItem" }
    location { "D-Space" }
    description { "An audited item" }
    image { nil }
    price_ct { 42 }
    rental_duration_sec { 42 }
    lend_status { :available }
    owning_user { create(:user) }
  end

  factory :available_item, class: 'Item' do
    name { "AvailableItem" }
    type { "OtherItem" }
    location { "D-Space" }
    description { "This item is available." }
    image { Rack::Test::UploadedFile.new('spec/testimages/test_image.png', 'image/png') }
    price_ct { 500 }
    rental_duration_sec { 100 }
    rental_start { nil }
    lend_status { :available }
    owning_user { create(:user) }
  end

  factory :lent_item, class: 'Item' do
    name { "LentItem" }
    type { "OtherItem" }
    location { "D-Space" }
    description { "This item is lent." }
    image { Rack::Test::UploadedFile.new('spec/testimages/test_image.png', 'image/png') }
    price_ct { 500 }
    rental_duration_sec { 100 }
    rental_start { nil }
    lend_status { :lent }
    owning_user { create(:user) }
  end
end

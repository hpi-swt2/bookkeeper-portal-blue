FactoryBot.define do
  factory :other_item do
    name { "MovieItem" }
    location { "MyLocation" }
    description { "MyDescription" }
    image { Rack::Test::UploadedFile.new('spec/testimages/test_image.png', 'image/png') }
    price_ct { 1 }
    rental_duration_sec { 1 }
    rental_start { "2022-11-18 15:32:07" }
    return_checklist { "MyChecklist" }
    lend_status { :available }
    owning_user { create(:user) }
    name { "OtherItem" }
  end
end

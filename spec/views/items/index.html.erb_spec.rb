require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before do
    assign(:items, [
             Item.create!(
               name: "Name",
               category: "Category",
               location: "Location",
               description: "MyText",
               image: nil,
               price_ct: 2,
               rental_duration_sec: 3,
               return_checklist: "MyOwnText"
             ),
             Item.create!(
               name: "Name",
               category: "Category",
               location: "Location",
               description: "MyText",
               image: nil,
               price_ct: 2,
               rental_duration_sec: 3,
               return_checklist: "MyOwnText"
             )
           ])
  end

  it "renders a list of items" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Category".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Location".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    # assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyOwnText".to_s), count: 2
  end
end

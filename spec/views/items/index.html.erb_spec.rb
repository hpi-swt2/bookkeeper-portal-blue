require 'rails_helper'

RSpec.describe "items/index", type: :view do
  num_items = 2
  before do
    assign(:items, create_list(:item, num_items))
  end

  it "renders a list of items" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: num_items
    assert_select cell_selector, text: Regexp.new("Category".to_s), count: num_items
    assert_select cell_selector, text: Regexp.new("Location".to_s), count: num_items
    assert_select cell_selector, text: Regexp.new("MyDescription".to_s), count: num_items
    assert_select cell_selector, text: Regexp.new(2.to_s), count: num_items
    assert_select cell_selector, text: Regexp.new(3.to_s), count: num_items
    assert_select cell_selector, text: Regexp.new("MyChecklist".to_s), count: num_items
  end
end

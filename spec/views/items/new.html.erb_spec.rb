require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before(:each) do
    assign(:item, Item.new(
      name: "MyString",
      category: "MyString",
      location: "MyString",
      description: "MyText",
      image: nil,
      price_ct: 1,
      rental_duration_sec: 1,
      return_checklist: "MyText"
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[category]"

      assert_select "input[name=?]", "item[location]"

      assert_select "textarea[name=?]", "item[description]"

      assert_select "input[name=?]", "item[image]"

      assert_select "input[name=?]", "item[price_ct]"

      assert_select "input[name=?]", "item[rental_duration_sec]"

      assert_select "textarea[name=?]", "item[return_checklist]"
    end
  end
end

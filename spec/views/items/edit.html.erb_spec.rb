require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  let(:item) do
    Item.create!(
      name: "MyString",
      category: "MyString",
      location: "MyString",
      description: "MyText",
      image: nil,
      price_ct: 1,
      rental_duration_sec: 1,
      return_checklist: "MyText"
    )
  end

  before do
    assign(:item, item)
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(item), "post" do

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

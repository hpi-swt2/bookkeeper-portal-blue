require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before do
    assign(:item, build(:item))
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

      assert_select "input[name=?]", "item[rental_duration_days]"

      assert_select "textarea[name=?]", "item[return_checklist]"

      assert_select "select[name=?]", "item[owner_id]"

      assert_select "select[name=?]", "item[holder]"
    end
  end
end

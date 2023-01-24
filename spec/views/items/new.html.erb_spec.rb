require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before do
    assign(:item, build(:item))
    # https://stackoverflow.com/a/54700034/11057370
    allow(view).to receive(:current_user)
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

      assert_select "select[name=?]", "item[owner_id]"

      assert_select "select[id=?]", "item_see_group_ids"

      assert_select "select[id=?]", "item_lend_group_ids"
    end
  end
end

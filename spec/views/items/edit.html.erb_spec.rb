require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  let(:item) do
    create(:item)
  end

  before do
    assign(:item, item)
    # https://stackoverflow.com/a/54700034/11057370
    allow(view).to receive(:current_user)
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(item), "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[category]"

      assert_select "input[name=?]", "item[location]"

      assert_select "textarea[name=?]", "item[description]"

      assert_select "input[name=?]", "item[image]"

      assert_select "input[name=?]", "item[rental_duration_sec]"

      assert_select "select[name=?]", "item[owner_id]"

    end
  end
end

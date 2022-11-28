require 'rails_helper'

RSpec.describe "search/index", type: :view do
  it "renders the search form" do
    render

    assert_select "form[method=?]", "get" do

      assert_select "input[type=?][id=?]", "text", "search"

      assert_select "select[id=?]", "filter_property"

      assert_select "input[type=?][id=?]", "text", "filter_value"

      assert_select "button[type=?]", "submit"
    end
  end
end

require 'rails_helper'

RSpec.describe "items/show", type: :view do
  before do
    assign(:item, Item.create!(
                    name: "Name",
                    category: "Category",
                    location: "Location",
                    description: "MyText",
                    image: nil,
                    price_ct: 2,
                    rental_duration_sec: 3,
                    return_checklist: "MyText"
                  ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
  end
end

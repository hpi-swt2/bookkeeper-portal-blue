require 'rails_helper'

RSpec.describe "items/show", type: :view do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:item) { create(:item, owner: user.id) }

  it "renders attributes in <p>" do
    render item
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyChecklist/)
  end

  it "shows edit button for owner" do
    sign_in user
    render item
    expect(rendered).to have_button(id: 'edit_item')
  end

  it "does not show edit button for non-owner" do
    sign_in user2
    render item
    expect(rendered).not_to have_button(id: 'edit_item')
  end
end

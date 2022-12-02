require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:item) { create(:item, owner: user.id) }

  it "renders attributes" do
    visit item_path(item)
    expect(page).to match(/Name/)
    expect(page).to match(/Category/)
    expect(page).to match(/Location/)
    expect(page).to match(/Description/)
    expect(page).to match(//)
    expect(page).to match(/Price/) # match(/2/)
    expect(page).to match(/Rental Duration/) # match(/3/)
    # expect(page).to have_text("Rental start")
    # expect(page).to have_text("Return checklist")
  end

  it "shows edit button for owner" do
    sign_in user
    visit item_path(item)
    expect(page).to have_button(id: "notFilledEditItemIcon")
  end

  it "does not show edit button for non-owner" do
    sign_in user2
    visit item_path(item)
    expect(page).not_to have_button(id: "destroy_item_button")
  end
end

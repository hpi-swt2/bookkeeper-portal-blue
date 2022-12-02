require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:item) { create(:item, owner: user.id) }

  it "renders attributes" do
    visit item_path(item)
    expect(page).to have_text(item.name)
    expect(page).to have_text(item.category)
    expect(page).to have_text(item.location)
    expect(page).to have_text(item.description)
    # expect(page).to match(//)
    # expect(page).to match(/Price/) # match(/2/)
    # expect(page).to match(/Rental Duration/) # match(/3/)
    # expect(page).to have_text("Rental start")
    # expect(page).to have_text("Return checklist")
  end

  it "shows edit button for owner" do
    sign_in user
    visit item_path(item)
    expect(page).to have_link(href: edit_item_url(item))
  end

  it "does not show edit button for non-owner" do
    sign_in user2
    visit item_path(item)
    expect(page).not_to have_button(id: "destroy_item_button")
  end
end

require 'rails_helper'

RSpec.describe "items/show", type: :feature do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:item) { create(:item, owner: user.id) }

  it "renders attributes" do
    visit item_path(item)
    expect(page).to have_text("Name")
    expect(page).to have_text("Category")
    expect(page).to have_text("Location")
    expect(page).to have_text("Description")
    expect(page).to have_text("Image")
    expect(page).to have_text("Price")
    expect(page).to have_text("Rental duration")
    expect(page).to have_text("Rental start")
    expect(page).to have_text("Return checklist")
  end

  it "shows edit button for owner" do
    sign_in user
    visit item_path(item)
    expect(page).to have_button(id: "edit_item_button")
  end

  it "does not show edit button for non-owner" do
    sign_in user2
    visit item_path(item)
    expect(page).not_to have_button(id: "destroy_item_button")
  end
end

require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:item) { create(:item, owner: user.id) }

  it "renders without rental start and duration set" do
    an_item = create(:item_without_time)
    visit item_url(an_item)
    expect(page).to have_text(Time.zone.now.advance(days: 1).strftime('%d.%m.%Y'))
  end

  it "shows edit button for owner" do
    sign_in user
    visit item_path(item)
    expect(page).to have_link(href: edit_item_url(item))
  end

  it "does not show edit button for non-owner" do
    sign_in user2
    visit item_path(item)
    expect(page).not_to have_link(href: edit_item_url(item))
  end

  it "renders attributes" do
    visit item_path(item)
    expect(page).to have_text(item.name)
    expect(page).to have_text(item.category)
    expect(page).to have_text(item.location)
    expect(page).to have_text(item.description)
  end
end

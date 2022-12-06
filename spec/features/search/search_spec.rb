require "rails_helper"

describe "Seach page", type: :feature do

  before do
    @item_book = create(:item_book)
    @item_beamer = create(:item_beamer)
    @item_whiteboard = create(:item_whiteboard)
    visit search_path
  end

  it "partial matching works for title" do
    page.fill_in "search", with: "Ruby"
    find('button[type="submit"]').click
    expect(page).to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "partial matching works for description" do
    page.fill_in "search", with: "book"
    find('button[type="submit"]').click
    expect(page).to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "partial matching works for empty string" do
    page.fill_in "search", with: "Ruby"
    find('button[type="submit"]').click
    expect(page).not_to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

end

require "rails_helper"

describe "Search page", type: :feature do
  before do
    @item_book = create(:item_book)
    @item_beamer = create(:item_beamer)
    @item_whiteboard = create(:item_whiteboard)
    visit search_path
  end

  it "translates the close button to German" do
    page.driver.header 'Accept-language', 'de-DE'
    visit search_path
    expect(page).to have_text("Schließen")
  end

  it "translates the close button to English by default" do
    visit search_path
    expect(page).to have_text("Close")
  end

  it "partial matching works for title" do
    page.fill_in "search", with: "Ruby"
    click_button("submit")
    expect(page).to have_text(@item_book.name)
    expect(page).to have_link href: item_path(@item_book)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "partial matching works for description" do
    page.fill_in "search", with: "book"
    click_button("submit")
    expect(page).to have_text(@item_book.name)
    expect(page).to have_link href: item_path(@item_book)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "partial matching works for empty string" do
    page.fill_in "search", with: ""
    click_button("submit")
    expect(page).not_to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "shows no item at first if you visit the page" do
    expect(page).not_to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "shows last search result when searching for nothing after searching for something" do
    page.fill_in "search", with: "book"
    click_button("submit")
    page.fill_in "search", with: ""
    click_button("submit")
    expect(page).to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

end

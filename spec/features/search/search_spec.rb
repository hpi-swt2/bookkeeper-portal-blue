require "rails_helper"

describe "Search page", type: :feature do
  before do
    @item_book = create(:item_book)
    @item_beamer = create(:item_beamer)
    @item_whiteboard = create(:item_whiteboard)
    @item_available = create(:available_item)
    @item_lent = create(:lent_item)
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
    expect(page).to have_text(@item_book.name)
    expect(page).to have_text(@item_beamer.name)
    expect(page).to have_text(@item_whiteboard.name)
  end

  it "shows all items at first if you visit the page" do
    expect(page).to have_text(@item_book.name)
    expect(page).to have_text(@item_beamer.name)
    expect(page).to have_text(@item_whiteboard.name)
  end

  it "shows all items when searching for nothing after searching for something" do
    page.fill_in "search", with: "book"
    click_button("submit")
    page.fill_in "search", with: ""
    click_button("submit")
    expect(page).to have_text(@item_book.name)
    expect(page).to have_text(@item_beamer.name)
    expect(page).to have_text(@item_whiteboard.name)
  end

  it "shows only the items with the correct category" do
    page.fill_in "search", with: "b"
    click_button("filter")
    select(@item_book.category, from: "category").select_option
    click_button("submit")

    expect(page).to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "shows only unavailable items when filtering for unavailability" do
    page.fill_in "search", with: "b"
    click_button("filter")
    select("Unavailable", from: "availability").select_option
    click_button("submit")

    expect(page).to have_text(@item_book.name)
    expect(page).to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "shows only available items when seraching for blank and having an availability filter" do
    select("Available", from: "availability").select_option
    click_button("submit")

    expect(page).not_to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).to have_text(@item_whiteboard.name)
  end

  it "applies both filters" do
    select("Unavailable", from: "availability").select_option
    select(@item_book.category, from: "category").select_option
    click_button("submit")

    expect(page).to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "shows all available categories" do
    click_button("filter")

    expect(page).to have_text(@item_book.category)
    expect(page).to have_text(@item_beamer.category)
    expect(page).to have_text(@item_whiteboard.category)
  end

  it "shows available items first" do
    page.fill_in "search", with: "item"
    click_button("submit")
    expect(page).to have_text(/#{@item_available.name}.*\n.*#{@item_lent.name}/)
  end
end

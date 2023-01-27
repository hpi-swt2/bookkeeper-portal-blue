require "rails_helper"

describe "Search page", type: :feature do
  before do
    @item_book = create(:item_book)
    @item_beamer = create(:item_beamer)
    @item_whiteboard = create(:item_whiteboard)
    @item_available = create(:available_item)
    @item_alphabetical_first = create(:alphabetical_first_item)
    @item_alphabetical_second = create(:alphabetical_second_item)
    @item_lent = create(:lent_item)
    @item_group = create(:item_owned_by_group)

    @audited_items = [
      create(:itemAudited0),
      create(:itemAudited1),
      create(:itemAudited2)
    ]

    @audited_items.each_with_index do |item, index|
      ((index + 1) * 10).times do
        create(:audit_event,
               item: item,
               event_type: :accept_lend)
        create(:audit_event,
               item: item,
               event_type: :accept_return)
      end
    end

    visit search_path
  end

  it "translates the close button to German" do
    visit search_path({ locale: 'de' })
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
    expect(page).to have_link href: item_path(@item_book, locale: RSpec.configuration.locale)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "partial matching works for description" do
    page.fill_in "search", with: "book"
    click_button("submit")
    expect(page).to have_text(@item_book.name)
    expect(page).to have_link href: item_path(@item_book, locale: RSpec.configuration.locale)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "keeps the result the same when searching multiple times" do
    page.fill_in "search", with: "book"
    click_button("submit")
    click_button("submit")

    expect(page).to have_text(@item_book.name)
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

  it "keeps the filter selected" do
    select(@item_beamer.category, from: "category").select_option
    select("Unavailable", from: "availability").select_option

    click_button("submit")
    click_button("submit")

    expect(page).not_to have_text(@item_book.name)
    expect(page).to have_text(@item_beamer.name)
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

  it "shows items sorted by name ascending" do
    I18n.with_locale(:en) do
      page.select "Name (A-Z)", from: 'order'
      page.fill_in "search", with: "alphabetical"
      click_button("submit")
      expect(page).to have_text(/#{@item_alphabetical_first.name}.*\n.*#{@item_alphabetical_second.name}/)
    end
  end

  it "shows items sorted by name descending" do
    I18n.with_locale(:en) do
      page.select "Name (Z-A)", from: 'order'
      page.fill_in "search", with: "alphabetical"
      click_button("submit")
      expect(page).to have_text(/#{@item_alphabetical_second.name}.*\n.*#{@item_alphabetical_first.name}/)
    end
  end

  it "shows only items belonging to the group" do
    page.select "TestGroup", from: 'group'
    click_button("submit")

    expect(page).to have_text("MyName")
    expect(page).not_to have_text(@item_book.name)
    expect(page).not_to have_text(@item_beamer.name)
    expect(page).not_to have_text(@item_whiteboard.name)
  end

  it "shows items sorted by popularity descending" do
    I18n.with_locale(:en) do
      page.select "Popularity", from: 'order'
      page.fill_in "search", with: "audited"
      click_button("submit")
      expect(page).to have_text(/#{@audited_items[2].name}.*\n.*#{@audited_items[1].name}/)
      expect(page).to have_text(/#{@audited_items[1].name}.*\n.*#{@audited_items[0].name}/)
    end
  end
end

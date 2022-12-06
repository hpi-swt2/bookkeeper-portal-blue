require "rails_helper"

describe "Search page", type: :feature do

  it "shows all items when searching for nothing" do
    @item = create(:item)
    @item_book = create(:item_book)

    visit search_path
    expect(page).to have_text(@item.name)
    expect(page).to have_text(@item_book.name)

    expect(page).to have_link href: item_path(@item)
    expect(page).to have_link href: item_path(@item_book)
  end

end

require 'rails_helper'

RSpec.describe "Search", type: :helper do
  include SearchHelper

  before do
    @item_book = create(:item_book)
    @item_beamer = create(:item_beamer)
    @item_whiteboard = create(:item_whiteboard)
  end

  it "Searches correctly for name" do
    results = search_for_items(@item_book.name)
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly case insensitive" do
    results = search_for_items(@item_book.name.downcase)
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly for description" do
    results = search_for_items(@item_book.description)
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly for empty string" do
    results = search_for_items("")
    expect(results.length).to be(0)
  end

  it "Searches correctly for string only with whitespaces" do
    results = search_for_items("   ")
    expect(results.length).to be(0)
  end

  it "Searches correctly for both items with 'to'" do
    results = search_for_items("to")
    expect(results).to include(@item_book)
    expect(results).to include(@item_beamer)
  end

  it "Searches correctly for partial matching" do
    results = search_for_items("Exampl")
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly for attribute 'category'" do
    results = search_for_items(@item_book.name, { "category" => "Books" })
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly for attribute 'category' exluding an item with a matching search term" do
    results = search_for_items("o", { "category" => "Equipment" })
    expect(results).not_to include(@item_book)
    expect(results).to include(@item_beamer)
    expect(results).to include(@item_whiteboard)
  end

  it "Searches correctly for attribute 'category' exluding everything" do
    results = search_for_items("o", { "category" => "wubciubciubw" })
    expect(results).not_to include(@item_book)
    expect(results).not_to include(@item_beamer)
    expect(results).not_to include(@item_whiteboard)
  end

  it "Searches correctly for numerical attribute 'price_ct' exluding an item with a matching search term" do
    results = search_for_items("o", {}, { "price_ct" => { "lower_bound" => 100, "upper_bound" => 500 } })
    expect(results).not_to include(@item_book)
    expect(results).to include(@item_beamer)
    expect(results).to include(@item_whiteboard)
  end

  it "Searches correctly for numerical attribute 'price_ct' exluding everything" do
    results = search_for_items("o", {}, { "price_ct" => { "lower_bound" => 2, "upper_bound" => 3 } })
    expect(results).not_to include(@item_book)
    expect(results).not_to include(@item_beamer)
    expect(results).not_to include(@item_whiteboard)
  end

  it "Searches correctly for numerical attribute 'price_ct' with exact amount" do
    results = search_for_items("o", {}, { "price_ct" => { "lower_bound" => 100, "upper_bound" => 100 } })
    expect(results).not_to include(@item_book)
    expect(results).to include(@item_beamer)
    expect(results).not_to include(@item_whiteboard)
  end

  it "Searches correctly for numerical attribute and categorical attribute" do
    results = search_for_items("o", { "category" => "Equipment" },
                               { "price_ct" => { "lower_bound" => 500, "upper_bound" => 10_000 } })
    expect(results).not_to include(@item_book)
    expect(results).not_to include(@item_beamer)
    expect(results).to include(@item_whiteboard)
  end

end

require 'rails_helper'

RSpec.describe "Search", type: :helper do
  include SearchHelper

  before do
    @user = create(:user)
    @item_book = create(:item_book, owning_user: @user)
    @item_beamer = create(:item_beamer, owning_user: @user)
    @item_whiteboard = create(:item_whiteboard, owning_user: @user)

    @audited_items = [
      create(:itemAudited0, owning_user: @user),
      create(:itemAudited1, owning_user: @user),
      create(:itemAudited2, owning_user: @user)
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
  end

  it "Searches correctly for name" do
    results = search_for_items(@user, @item_book.name)
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly case insensitive" do
    results = search_for_items(@user, @item_book.name.downcase)
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly for description" do
    results = search_for_items(@user, @item_book.description)
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly for empty string" do
    results = search_for_items(@user, "")
    expect(results.length).to be(6)
  end

  it "Searches correctly for string only with whitespaces" do
    results = search_for_items(@user, "   ")
    expect(results.length).to be(6)
  end

  it "Searches correctly for both items with 'to'" do
    results = search_for_items(@user, "to")
    expect(results).to include(@item_book)
    expect(results).to include(@item_beamer)
  end

  it "Searches correctly for partial matching" do
    results = search_for_items(@user, "Exampl")
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly for attribute 'category'" do
    results = search_for_items(@user, @item_book.name, { "category" => "Books" })
    expect(results).to include(@item_book)
    expect(results).not_to include(@item_beamer)
  end

  it "Searches correctly for attribute 'category' exluding an item with a matching search term" do
    results = search_for_items(@user, "o", { "category" => "Equipment" })
    expect(results).not_to include(@item_book)
    expect(results).to include(@item_beamer)
    expect(results).to include(@item_whiteboard)
  end

  it "Searches correctly for attribute 'category' exluding everything" do
    results = search_for_items(@user, "o", { "category" => "wubciubciubw" })
    expect(results).not_to include(@item_book)
    expect(results).not_to include(@item_beamer)
    expect(results).not_to include(@item_whiteboard)
  end

  it "Searches correctly for numerical attribute 'price_ct' exluding an item with a matching search term" do
    results = search_for_items(@user, "o", {}, { "price_ct" => { "lower_bound" => 100, "upper_bound" => 500 } })
    expect(results).not_to include(@item_book)
    expect(results).to include(@item_beamer)
    expect(results).to include(@item_whiteboard)
  end

  it "Searches correctly for numerical attribute 'price_ct' exluding everything" do
    results = search_for_items(@user, "o", {}, { "price_ct" => { "lower_bound" => 2, "upper_bound" => 3 } })
    expect(results).not_to include(@item_book)
    expect(results).not_to include(@item_beamer)
    expect(results).not_to include(@item_whiteboard)
  end

  it "Searches correctly for numerical attribute 'price_ct' with exact amount" do
    results = search_for_items(@user, "o", {}, { "price_ct" => { "lower_bound" => 100, "upper_bound" => 100 } })
    expect(results).not_to include(@item_book)
    expect(results).to include(@item_beamer)
    expect(results).not_to include(@item_whiteboard)
  end

  it "Searches correctly for numerical attribute and categorical attribute" do
    results = search_for_items(@user, "o", { "category" => "Equipment" },
                               { "price_ct" => { "lower_bound" => 500, "upper_bound" => 10_000 } })
    expect(results).not_to include(@item_book)
    expect(results).not_to include(@item_beamer)
    expect(results).to include(@item_whiteboard)
  end

  it "rejects sql injections as search term parameter" do
    results = search_for_items(@user, "some-random-thing'/**/OR/**/1=1/**/OR/**/description/**/LIKE/**/'")
    expect(results).not_to include(@item_book)
    expect(results).not_to include(@item_beamer)
    expect(results).not_to include(@item_whiteboard)
  end

  it "puts items in the correct order when sorted by popularity" do
    @audited_items.take(@audited_items.size - 1)
                  .zip(@audited_items.drop(1))
                  .collect do |first_item, second_item|
      expect(helper.statistics_item_popularity(first_item)).to be <= helper.statistics_item_popularity(second_item)
    end
  end

  it "sorts items correctly by popularity descending and ascending" do
    descending_sorted_items = helper.statistics_sort_items_by_popularity(@audited_items)
    ascending_sorted_items = helper.statistics_sort_items_by_popularity(@audited_items, :asc)
    descending_sorted_items.zip(ascending_sorted_items)
                           .each_with_index do |(desc_item, asc_item), index|
      expect(desc_item).to be == @audited_items[@audited_items.length - index - 1]
      expect(asc_item).to be == @audited_items[index]
    end
  end
end

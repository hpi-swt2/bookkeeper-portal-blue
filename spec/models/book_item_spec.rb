require 'rails_helper'

RSpec.describe BookItem, type: :model do
  let(:book_item) { build(:book_item) }

  it "is creatable via a factory" do
    expect(book_item).to be_valid
  end

  it "has the correct type" do
    expect(book_item.type).to eq "BookItem"
  end

  it 'is not valid when the genre or author is missing' do
    expect(build(:book_item, genre: nil)).not_to be_valid
    expect(build(:book_item, author: nil)).not_to be_valid
  end

  it 'is not valid when it has a movie duration or player count' do
    expect(build(:book_item, movie_duration: 42)).not_to be_valid
    expect(build(:book_item, player_count: 42)).not_to be_valid
  end
end

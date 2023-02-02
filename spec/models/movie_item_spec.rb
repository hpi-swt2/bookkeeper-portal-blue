require 'rails_helper'

RSpec.describe MovieItem, type: :model do
  let(:movie_item) { build(:movie_item) }

  it "is creatable via a factory" do
    expect(movie_item).to be_valid
  end

  it "has the correct type" do
    expect(movie_item.type).to eq "MovieItem"
  end

  it 'is not valid when the title, genre or movie duration is missing or invalid' do
    expect(build(:movie_item, title: nil)).not_to be_valid
    expect(build(:movie_item, genre: nil)).not_to be_valid
    expect(build(:movie_item, movie_duration: nil)).not_to be_valid
    expect(build(:movie_item, movie_duration: -5)).not_to be_valid
  end

  it 'is not valid when it has an author, page count or player count' do
    expect(build(:movie_item, author: "Boris")).not_to be_valid
    expect(build(:movie_item, page_count: 42)).not_to be_valid
    expect(build(:movie_item, player_count: 42)).not_to be_valid
  end
end

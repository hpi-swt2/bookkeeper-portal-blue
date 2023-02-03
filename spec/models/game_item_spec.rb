require 'rails_helper'

RSpec.describe GameItem, type: :model do
  let(:game_item) { build(:game_item) }

  it "is creatable via a factory" do
    expect(game_item).to be_valid
  end

  it "has the correct type" do
    expect(game_item.type).to eq "GameItem"
  end

  it 'is not valid when the author or player count is missing or invalid' do
    expect(build(:game_item, author: nil)).not_to be_valid
    expect(build(:game_item, player_count: nil)).not_to be_valid
    expect(build(:game_item, player_count: -5)).not_to be_valid
  end

  it 'is not valid when it has a genre, movie duration or page count' do
    expect(build(:game_item, genre: "MMO")).not_to be_valid
    expect(build(:game_item, movie_duration: 42)).not_to be_valid
    expect(build(:game_item, page_count: 42)).not_to be_valid
  end
end

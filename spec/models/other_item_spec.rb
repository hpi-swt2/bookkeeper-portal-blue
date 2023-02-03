require 'rails_helper'

RSpec.describe OtherItem, type: :model do
  let(:other_item) { build(:other_item) }

  it "is creatable via a factory" do
    expect(other_item).to be_valid
  end

  it "has the correct type" do
    expect(other_item.type).to eq "OtherItem"
  end

  it 'is not valid when it has any custom subclass attributes' do
    expect(build(:other_item, author: "Boris")).not_to be_valid
    expect(build(:other_item, genre: "Sonstiges")).not_to be_valid
    expect(build(:other_item, movie_duration: 42)).not_to be_valid
    expect(build(:other_item, page_count: 42)).not_to be_valid
    expect(build(:other_item, player_count: 42)).not_to be_valid
  end
end

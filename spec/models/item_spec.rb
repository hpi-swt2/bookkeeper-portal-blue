require 'rails_helper'

RSpec.describe Item, type: :model do

  before do
    @user = create(:user)
  end

  it "handles item price setting/getting correctly" do
    item = build(:item)
    price = 8.5
    item.price_in_euro = price
    expect(item.price_in_euro[0]).to eq(8)
    expect(item.price_in_euro[1]).to eq(50)
    expect(item.price_ct).to eq(price * 100)
  end

  it "is valid with all required attributes" do
    item = described_class.new(name: "Test", category: "Test", location: "Test", description: "Test", owner: @user.id)
    expect(item).to be_valid
  end

  it "is not valid without name" do
    item = described_class.new(category: "Test", location: "Test", description: "Test", owner: @user.id)
    expect(item).not_to be_valid
  end

  it "is not valid without category" do
    item = described_class.new(name: "Test", location: "Test", description: "Test", owner: @user.id)
    expect(item).not_to be_valid
  end

  it "is not valid without location" do
    item = described_class.new(name: "Test", category: "Test", description: "Test", owner: @user.id)
    expect(item).not_to be_valid
  end

  it "is not valid without owner" do
    item = described_class.new(name: "Test", category: "Test", location: "Test", description: "Test")
    expect(item).not_to be_valid
  end

  it "is not valid without description" do
    item = described_class.new(name: "Test", category: "Test", location: "Test", owner: @user.id)
    expect(item).not_to be_valid
  end

  it "is not valid with negative price" do
    item = described_class.new(name: "Test", category: "Test", location: "Test", description: "Test", owner: @user.id, price_ct: -1)
    expect(item).not_to be_valid
  end
end

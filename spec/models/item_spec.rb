require 'rails_helper'

RSpec.describe Item, type: :model do

  before do
    @user = create(:user)
    @group = create(:group)
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
    item = described_class.new(name: "Test", category: "Test", location: "Test", description: "Test",
                               owning_user: @user)
    expect(item).to be_valid
  end

  it "is valid with all required attributes and group instead of user as owner" do
    item = described_class.new(name: "Test", category: "Test", location: "Test", description: "Test",
                               owning_group: @group)
    expect(item).to be_valid
  end

  it "is not valid without name" do
    item = described_class.new(category: "Test", location: "Test", description: "Test", owning_user: @user)
    expect(item).not_to be_valid
  end

  it "is not valid without category" do
    item = described_class.new(name: "Test", location: "Test", description: "Test", owning_user: @user)
    expect(item).not_to be_valid
  end

  it "is not valid without location" do
    item = described_class.new(name: "Test", category: "Test", description: "Test", owning_user: @user)
    expect(item).not_to be_valid
  end

  it "is not valid without owner" do
    item = described_class.new(name: "Test", category: "Test", location: "Test", description: "Test")
    expect(item).not_to be_valid
  end

  it "is valid without description" do
    item = described_class.new(name: "Test", category: "Test", location: "Test", owning_user: @user)
    expect(item).to be_valid
  end

  it "is not valid with negative price" do
    item = described_class.new(name: "Test", category: "Test", location: "Test", description: "Test",
                               owning_user: @user, price_ct: -1)
    expect(item).not_to be_valid
  end

  it "resets the owning user when setting an owning group" do
    item = create(:item)
    expect(item.owning_user).not_to be_nil
    expect(item.owning_group).to be_nil

    item.owning_group = create(:group)
    item.reload
    expect(item.owning_user).to be_nil
    expect(item.owning_group).not_to be_nil
  end

  it "resets the owning group when setting an owning user" do
    item = create(:item_owned_by_group)
    expect(item.owning_user).to be_nil
    expect(item.owning_group).not_to be_nil

    item.owning_user = create(:user)
    item.reload
    expect(item.owning_user).not_to be_nil
    expect(item.owning_group).to be_nil
  end

  it "permits the owning user to lend" do
    item = create(:item)
    expect(item.users_with_lend_permission).to include(item.owning_user)
  end

  it "permits the owning group to lend" do
    item = create(:item_owned_by_group)
    expect(item.groups_with_lend_permission).to include(item.owning_group)
  end

  it "permits the owning user to see" do
    item = create(:item)
    expect(item.users_with_see_permission).to include(item.owning_user)
  end

  it "permits the owning group to see" do
    item = create(:item_owned_by_group)
    expect(item.groups_with_see_permission).to include(item.owning_group)
  end

  it "permits users from the owning group to own" do
    item = create(:item_owned_by_group)
    item.owning_group.members << @user
    expect(item.users_with_ownership_permission).to include(@user)
  end

  it "permits users with direct lend permission to see" do
    item = create(:item)
    item.users_with_direct_lend_permission << @user
    expect(item.users_with_see_permission).to include(@user)
  end

  it "permits users with indirect lend permission to see" do
    item = create(:item)
    item.groups_with_lend_permission << @group
    @group.members << @user
    expect(item.users_with_see_permission).to include(@user)
  end

  it "permits groups with lend permission to see" do
    item = create(:item)
    item.groups_with_lend_permission << @group
    expect(item.groups_with_see_permission).to include(@group)
  end

  it "does not permit arbitrary users to own" do
    item = create(:item)
    expect(item.users_with_ownership_permission).not_to include(@user)
  end

  it "does not permit users with direct lend permission to own" do
    item = create(:item)
    item.users_with_direct_lend_permission << @user
    expect(item.users_with_ownership_permission).not_to include(@user)
  end

  it "does not permit users with indirect lend permission to own" do
    item = create(:item)
    item.groups_with_lend_permission << @group
    @group.members << @user
    expect(item.users_with_ownership_permission).not_to include(@user)
  end

  it "does not permit users with direct see permission to lend" do
    item = create(:item)
    item.users_with_direct_see_permission << @user
    expect(item.users_with_lend_permission).not_to include(@user)
  end

  it "does not permit users with indirect see permission to lend" do
    item = create(:item)
    item.groups_with_see_permission << @group
    @group.members << @user
    expect(item.users_with_lend_permission).not_to include(@user)
  end

  it "does not permit groups with see permission to lend" do
    item = create(:item)
    item.groups_with_see_permission << @group
    expect(item.groups_with_lend_permission).not_to include(@group)
  end
end

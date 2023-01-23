require 'rails_helper'

RSpec.describe Group, type: :model do

  before do
    @group = create(:group)
  end

  it "can be created using a factory" do
    expect(@group).to be_valid
  end

  it "is not valid without an owner by default" do
    @group.owners.delete_all
    expect(@group).not_to be_valid
  end

  it "is is valid without an owner if it is not user-defined" do
    @group.system_name = "test-group"
    @group.owners.delete_all
    expect(@group).to be_valid
  end

  it "lists owners in the list of members" do
    user = build(:user)
    @group.owners.append(user)

    expect(@group.owners).to include(user)
    expect(@group.members).to include(user)
  end

  it "only list owners in the list of owners" do
    user = build(:user)
    @group.members.append(user)

    expect(@group.members).to include(user)
    expect(@group.owners).not_to include(user)
  end

  it "includes a user at most once" do
    user = build(:user)
    @group.members.append(user)

    expect { @group.members.append(user) }.to raise_error(ActiveRecord::RecordNotUnique)
    expect { @group.owners.append(user) }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "can own items" do
    item = create(:item_owned_by_group)
    expect(item.owning_group.owned_items).to include(item)
  end

  it "can lend owned items" do
    item = create(:item_owned_by_group)
    expect(item.owning_group.lendable_items).to include(item)
  end

  it "can see owned items" do
    item = create(:item_owned_by_group)
    expect(item.owning_group.visible_items).to include(item)
  end

  it "can have lend permission on items" do
    item = create(:item)
    item.groups_with_lend_permission << @group
    expect(@group.lendable_items).to include(item)
  end

  it "can see lendable items" do
    item = create(:item)
    item.groups_with_lend_permission << @group
    expect(@group.visible_items).to include(item)
  end

  it "does not own lendable items" do
    item = create(:item)
    item.groups_with_lend_permission << @group
    expect(@group.owned_items).not_to include(item)
  end

  it "can have see permission on items" do
    item = create(:item)
    item.groups_with_see_permission << @group
    expect(@group.visible_items).to include(item)
  end

  it "cannot lend visible items" do
    item = create(:item)
    item.groups_with_see_permission << @group
    expect(@group.lendable_items).not_to include(item)
  end

  it "does not own visible items" do
    item = create(:item)
    item.groups_with_see_permission << @group
    expect(@group.owned_items).not_to include(item)
  end
end

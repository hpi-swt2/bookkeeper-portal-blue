require 'rails_helper'

describe User, type: :model do
  let(:user) { build(:max) }

  it "can be created using a factory" do
    expect(user).to be_valid
  end

  it "has an email attribute" do
    expect(user.email).not_to be_blank
  end

  it "has a first name" do
    expect(user.first_name).not_to be_blank
  end

  it "has a last name" do
    expect(user.last_name).not_to be_blank
  end

  it "has a full name" do
    expect(user.name).not_to be_blank
  end

  it "can own a group" do
    @group = create(:group)
    @group.owners.append(user)

    expect(user.groups).to include(@group)
    expect(user.owned_groups).to include(@group)
  end

  it "can be non-owner member of a group" do
    @group = create(:group)
    @group.members.append(user)

    expect(user.groups).to include(@group)
    expect(user.owned_groups).not_to include(@group)
  end

  it "can be promoted from member to owner" do
    @group = create(:group)
    @group.members.append(user)

    user.to_owner_of!(@group)
    expect(user.groups).to include(@group)
    expect(user.owned_groups).to include(@group)
  end

  it "can be demoted from owner to member" do
    @group = create(:group)
    @group.owners.append(user)

    user.to_member_of!(@group)
    expect(user.groups).to include(@group)
    expect(user.owned_groups).not_to include(@group)
  end

  it "can own items" do
    item = create(:item)
    expect(item.owning_user.owned_items).to include(item)
  end

  it "can lend owned items" do
    item = create(:item)
    expect(item.owning_user.lendable_items).to include(item)
  end

  it "can see owned items" do
    item = create(:item)
    expect(item.owning_user.visible_items).to include(item)
  end

  it "can have lend permission on items" do
    item = create(:item)
    item.users_with_direct_lend_permission << user
    expect(user.lendable_items).to include(item)
  end

  it "can see lendable items" do
    item = create(:item)
    item.users_with_direct_lend_permission << user
    expect(user.visible_items).to include(item)
  end

  it "does not own lendable items" do
    item = create(:item)
    item.users_with_direct_lend_permission << user
    expect(user.owned_items).not_to include(item)
  end

  it "can have see permission on items" do
    item = create(:item)
    item.users_with_direct_see_permission << user
    expect(user.visible_items).to include(item)
  end

  it "cannot lend visible items" do
    item = create(:item)
    item.users_with_direct_see_permission << user
    expect(user.lendable_items).not_to include(item)
  end

  it "does not own visible items" do
    item = create(:item)
    item.users_with_direct_see_permission << user
    expect(user.owned_items).not_to include(item)
  end
end

require 'rails_helper'

RSpec.describe Group, type: :model do

  before do
    @group = build(:group)
  end

  it "can be created using a factory" do
    expect(@group).to be_valid
  end

  it "is not valid without an owner" do
    @group.owners.delete_all
    expect(@group).not_to be_valid
  end

  it "marks itself as an owned group when adding owners" do
    user = build(:user)
    @group.owners.append(user)

    @group.save
    user.reload

    expect(user.groups).to include(@group)
    expect(user.owned_groups).to include(@group)
  end

  it "only marks itself as a group when addings members" do
    user = build(:user)
    @group.members.append(user)

    @group.save
    user.reload

    expect(user.groups).to include(@group)
    expect(user.owned_groups).not_to include(@group)
  end

  it "lists owners in the list of members" do
    user = build(:user)
    @group.owners.append(user)

    @group.save

    expect(@group.owners).to include(user)
    expect(@group.members).to include(user)
  end

  it "only list members in the list of members" do
    user = build(:user)
    @group.members.append(user)

    @group.save

    expect(@group.members).to include(user)
    expect(@group.owners).not_to include(user)
  end
end

require 'rails_helper'

RSpec.describe Group, type: :model do

  before do
    @group = create(:group)
  end

  it "can be created using a factory" do
    expect(@group).to be_valid
  end

  it "is not valid without an owner" do
    @group.owners.delete_all
    expect(@group).not_to be_valid
  end

  it "lists owners in the list of members" do
    user = build(:user)
    @group.owners.append(user)

    expect(@group.owners).to include(user)
    expect(@group.members).to include(user)
  end

  it "only list members in the list of members" do
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
end

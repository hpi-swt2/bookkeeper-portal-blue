require 'rails_helper'

RSpec.describe Waitlist, type: :model do
  it "is valid with all required attributes" do
    waitlist = create(:waitlist_with_item)
    expect(waitlist).to be_valid
  end

  it "is not valid without an item" do
    waitlist = described_class.new
    expect(waitlist).not_to be_valid
  end

  it "returns the correct position" do
    waitlist = create(:waitlist_with_item)
    expect(waitlist.position(waitlist.users[0])).to eq(0)
    expect(waitlist.position(waitlist.users[1])).to eq(1)
  end

  it "returns correct first user" do
    waitlist = create(:waitlist_with_item)
    expect(waitlist.first_user).to eq(waitlist.users[0])
  end

  it "adds a user to the waitlist" do
    waitlist = create(:waitlist_with_item)
    user = create(:peter)
    expect(waitlist.add_user(user)).to be(true)
    expect(waitlist.users).to include(user)
  end

  it "does not add item owner to waitlist" do
    waitlist = create(:waitlist_with_item)
    owner = User.find(waitlist.item.owner)
    expect(waitlist.add_user(owner)).to be(false)
    expect(waitlist.users).not_to include(owner)
  end

  it "removes a user from the waitlist" do
    waitlist = create(:waitlist_with_item)
    user = waitlist.users[0]
    waitlist.remove_user(user)
    expect(waitlist.users).not_to include(user)
  end

  it "creates a notification when a user is added to the waitlist" do
    waitlist = create(:waitlist_with_item)
    user = create(:peter)
    waitlist.add_user(user)
    notification = AddedToWaitlistNotification.find_by(user: user, item: waitlist.item)
    expect(notification).not_to be_nil
  end

  it "creates a moved up notification for users after when a user is removed from the waitlist" do
    waitlist = create(:waitlist_with_item)
    user = waitlist.users[0]
    waitlist.remove_user(user)
    notification = MoveUpOnWaitlistNotification.find_by(user: waitlist.users[0], item: waitlist.item)
    expect(notification).not_to be_nil
  end
end

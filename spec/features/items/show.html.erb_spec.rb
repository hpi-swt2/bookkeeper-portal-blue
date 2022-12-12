require 'rails_helper'
require 'pp'
RSpec.describe "items/show", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:item) do
    item = create(:item, owner: user.id) 
    item.waitlist = create(:waitlist_with_item)
    item.waitlist.item = item
    item
  end

  it "renders without rental start and duration set" do
    sign_in user
    an_item = create(:item_without_time, waitlist: create(:waitlist_with_item))
    visit item_url(an_item)
    expect(page).to have_text(Time.zone.now.advance(days: 1).strftime('%d.%m.%Y'))
  end

  it "shows edit button for owner" do
    sign_in user
    visit item_path(item)
    expect(page).to have_link(href: edit_item_url(item))
  end

  it "does not show edit button for non-owner" do
    sign_in user2
    visit item_path(item)
    expect(page).not_to have_link(href: edit_item_url(item))
  end

  it "renders attributes" do
    sign_in user
    visit item_path(item)
    expect(page).to have_text(item.name)
    expect(page).to have_text(item.category)
    expect(page).to have_text(item.location)
    expect(page).to have_text(item.description)
  end

  # tests:
  # - has add to waitlist button when not on list
  # - has remove from waitlist button when on list
  # - buttons perform actions correctly
  # - creates added / move up notifications

  it "has enter waitlist button when not on list" do
    sign_in user2
    visit item_path(item)
    expect(page).to have_text("Enter Waitlist")
  end

  it "has leave waitlist button when on list" do
    sign_in user2
    item.waitlist.add_user(user2)
    visit item_path(item)
    expect(page).to have_text("Leave Waitlist")
  end

  it "adds user to waitlist when clicking add to waitlist button" do
    sign_in user2
    visit item_path(item)
    find(:button, "Enter Waitlist").click
    expect(Item.find(item.id).waitlist.users).to include(user2)
  end

  it "removes user from waitlist when clicking remove from waitlist button" do
    sign_in user2
    item.waitlist.add_user(user2)
    visit item_path(item)
    find(:button, "Leave Waitlist").click
    expect(Item.find(item.id).waitlist.users).to_not include(user2)
  end

  it "creates added to waitlist notification when adding user to waitlist" do
    sign_in user2
    visit item_path(item)
    find(:button, "Enter Waitlist").click
    notification = AddedToWaitlistNotification.find_by(user: user2, item: item)
    expect(notification).to_not be_nil
  end

  it "creates move up on waitlist notification when removing user from waitlist" do
    sign_in item.waitlist.users[0]
    item.waitlist.add_user(user2)
    visit item_path(item)
    find(:button, "Leave Waitlist").click
    notification = MoveUpOnWaitlistNotification.find_by(user: Item.find(item.id).waitlist.users[0], item: item)
    expect(notification).to_not be_nil
  end

end

require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  let(:owner) { create(:user) }
  let(:user) { create(:user) }
  let(:borrower) { create(:user) }
  let(:item) do
    item = create(:item, owner: owner.id)
    item.waitlist = create(:waitlist_with_item)
    item.waitlist.item = item
    item
  end
  let(:item_lent) do
    item_lent = create(:lent, owner: owner.id, holder: borrower.id)
    item_lent.waitlist = create(:waitlist_with_item)
    item_lent.waitlist.item = item_lent
    item_lent
  end

  it "renders without rental start and duration set" do
    sign_in user
    an_item = create(:item_without_time, waitlist: create(:waitlist_with_item))
    visit item_url(an_item)
    expect(page).to have_text(Time.zone.now.advance(days: 1).strftime('%d.%m.%Y'))
  end

  it "shows edit button for owner" do
    sign_in owner
    visit item_path(item)
    expect(page).to have_link(href: edit_item_url(item))
  end

  it "does not show edit button for non-owner" do
    sign_in user
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

  it "has lend button when item is available and not owner of item" do
    sign_in user
    visit item_path(item)
    expect(page).to have_button("Lend")
  end

  it "has pending lend request button when item is lent but not approved" do
    sign_in user
    visit item_path(item)
    find(:button, "Lend").click
    expect(page).to have_button("Waiting for lend approval", disabled: true)
  end

  it "creates audit event when requesting for lending" do
    sign_in user
    visit item_path(item)
    find(:button, "Lend").click
    expect(AuditEvent.where(item_id: item.id, event_type: "request_lend", triggering_user: user).count).to be(1)
  end

  it "has return button when item is lent by borrower" do
    sign_in borrower
    visit item_path(item_lent)
    expect(page).to have_button("Return")
  end

  it "has pending return request button when item is returned but not approved" do
    sign_in borrower
    visit item_path(item_lent)
    find(:button, "Return").click
    expect(page).to have_button("Waiting for return approval", disabled: true)
  end

  it "creates audit event when requesting for returning" do
    sign_in borrower
    visit item_path(item_lent)
    find(:button, "Return").click
    expect(AuditEvent.where(item_id: item_lent.id, event_type: "request_return", triggering_user: borrower).count).to be(1)
  end

  it "has enter waitlist button when not on list and item not available" do
    sign_in user
    visit item_path(item_lent)
    expect(page).to have_button("Enter Waitlist")
  end

  it "does not have an adaptive lend button when owner of item" do
    sign_in owner
    visit item_path(item)
    expect(page).not_to have_button("Lend")
    expect(page).not_to have_button("Waiting for lend approval")
    expect(page).not_to have_button("Return")
    expect(page).not_to have_button("Waiting for return approval")
    expect(page).not_to have_button("Enter Waitlist")
    expect(page).not_to have_button("Leave Waitlist")
  end

  it "has leave waitlist button when on list" do
    sign_in user
    item_lent.waitlist.add_user(user)
    visit item_path(item_lent)
    expect(page).to have_button("Leave Waitlist")
  end

  it "adds user to waitlist when clicking add to waitlist button" do
    sign_in user
    visit item_path(item_lent)
    find(:button, "Enter Waitlist").click
    expect(Item.find(item_lent.id).waitlist.users).to include(user)
  end

  it "creates audit event when entering for waitlist" do
    sign_in user
    visit item_path(item_lent)
    find(:button, "Enter Waitlist").click
    expect(AuditEvent.where(item_id: item_lent.id, event_type: "add_to_waitlist", triggering_user: user).count).to be(1)
  end

  it "removes user from waitlist when clicking remove from waitlist button" do
    sign_in user
    item_lent.waitlist.add_user(user)
    visit item_path(item_lent)
    find(:button, "Leave Waitlist").click
    expect(Item.find(item_lent.id).waitlist.users).not_to include(user)
  end

  it "creates audit event when leaving waitlist" do
    sign_in user
    item_lent.waitlist.add_user(user)
    visit item_path(item_lent)
    find(:button, "Leave Waitlist").click
    expect(AuditEvent.where(item_id: item_lent.id, event_type: "leave_waitlist", triggering_user: user).count).to be(1)
  end

  it "creates added to waitlist notification when adding user to waitlist" do
    sign_in user
    visit item_path(item_lent)
    find(:button, "Enter Waitlist").click
    notification = AddedToWaitlistNotification.find_by(user: user, item: item_lent)
    expect(notification).not_to be_nil
  end

  it "creates move up on waitlist notification when removing user from waitlist" do
    sign_in item_lent.waitlist.users[0]
    visit item_path(item_lent)
    find(:button, "Leave Waitlist").click
    notification = MoveUpOnWaitlistNotification.find_by(user: Item.find(item_lent.id).waitlist.users[0],
                                                        item: item_lent)
    expect(notification).not_to be_nil
  end

end

require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  let(:owner) { create(:user) }
  let(:user) { create(:user) }
  let(:borrower) { create(:user) }
  let(:item) do
    item = create(:item, owning_user: owner)
    item.waitlist = create(:waitlist_with_item)
    item.waitlist.item = item
    item
  end
  let(:item_lent) do
    item_lent = create(:lent, owning_user: owner, holder: borrower.id)
    item_lent.waitlist = create(:waitlist_with_item)
    item_lent.waitlist.item = item_lent
    item_lent
  end

  it "renders without rental start and duration set" do
    sign_in user
    an_item = create(:item_without_time, waitlist: create(:waitlist_with_item))
    visit item_url(an_item)
    expect(page).to have_text(ActiveSupport::Duration.build(86_400).inspect)
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

  it "shows edit button for group members, hides for others" do
    group = create(:group)
    member = group.owners[0]
    group_item = create(:item, owning_group: group)
    sign_in member
    visit item_path(group_item)
    expect(page).to have_link(href: edit_item_url(group_item))
    sign_in user
    visit item_path(group_item)
    expect(page).not_to have_link(href: edit_item_url(group_item))
  end

  it "shows qr button for owner" do
    sign_in owner
    visit item_path(item)
    expect(page).to have_link(text: /QR/)
  end

  it "does not show qr button for non-owner" do
    sign_in user
    visit item_path(item)
    expect(page).not_to have_link(text: /QR/)
  end

  it "shows qr button for group members, hides for others" do
    group = create(:group)
    member = group.owners[0]
    group_item = create(:item, owning_group: group)
    sign_in member
    visit item_path(group_item)
    expect(page).to have_link(text: /QR/)
    sign_in user
    visit item_path(group_item)
    expect(page).not_to have_link(text: /QR/)
  end

  it "renders attributes" do
    sign_in user
    visit item_path(item)
    expect(page).to have_text(item.name)
    expect(page).to have_text(item.category)
    expect(page).to have_text(item.location)
    expect(page).to have_text(item.description)
    expect(page).to have_text(item.rental_duration_sec)
  end

  it "renders owning group name" do
    group = create(:group)
    group_item = create(:item, owning_group: group)
    sign_in user
    visit item_path(group_item)
    expect(page).to have_text(group.name)
    visit item_path(item)
    expect(page).not_to have_text(group.name)
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
    expect(AuditEvent.where(item_id: item_lent.id, event_type: "request_return",
                            triggering_user: borrower).count).to be(1)
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
    notification = AddedToWaitlistNotification.find_by(receiver: user, item: item_lent)
    expect(notification).not_to be_nil
  end

  it "creates move up on waitlist notification when removing user from waitlist" do
    sign_in item_lent.waitlist.users[0]
    visit item_path(item_lent)
    find(:button, "Leave Waitlist").click
    notification = MoveUpOnWaitlistNotification.find_by(receiver: Item.find(item_lent.id).waitlist.users[0],
                                                        item: item_lent)
    expect(notification).not_to be_nil
  end

  it "does not display price when 0 or nil" do
    item_without_price = create(:item_without_price)
    visit item_path(item_without_price)
    expect(page).not_to have_text("Price")
    item_price_zero = create(:item_price_zero)
    visit item_path(item_price_zero)
    expect(page).not_to have_text("Price")
    visit item_path(item)
    expect(page).to have_text(item.price_ct)
  end

  it "displays return checklist only if not empty" do
    item_empty_return_checklist = create(:item_empty_return_checklist)
    visit item_path(item_empty_return_checklist)
    expect(page).not_to have_text("Return Checklist")

    visit item_path(item)
    expect(page).to have_text(item.return_checklist)
  end

  it "displays lent until if lent" do
    visit item_path(item_lent)
    expect(page).to have_text("Lent Until")
    lent_until = (item_lent.rental_start + item_lent.rental_duration_sec).strftime('%d.%m.%Y')
    expect(page).to have_text(lent_until)
  end

  it "does not show button to display waitlist if empty" do
    sign_in user
    item.waitlist.users.clear
    visit item_path(item)
    expect(page).not_to have_button("Show waitlist")
  end

  it "displays button to show waitlist if not empty" do
    sign_in user
    visit item_path(item)
    expect(page).to have_button("Show waitlist")
  end

  it "the waitlist contains order and names of people on it" do
    sign_in user
    visit item_path(item)
    find(:button, "Show waitlist").click
    expect(page).to have_text("1. #{item.waitlist.users[0].name}")
    expect(page).to have_text("2. #{item.waitlist.users[1].name}")
  end

end

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe "items/show", type: :feature do
  let(:owner) { create(:user) }
  let(:user) { create(:user) }
  let(:borrower) { create(:user) }
  let(:user_only_see_permissions) { create(:user) }
  let(:lend_group) do
    lend_group = create(:group)
    lend_group.members << user
    lend_group.members << borrower
    lend_group
  end
  let(:item) do
    item = create(:item, owning_user: owner, users_with_direct_see_permission: [user_only_see_permissions])
    item.waitlist = create(:waitlist, item: item)
    item.groups_with_lend_permission << lend_group
    item
  end
  let(:item_lent) do
    item_lent = create(:lent, owning_user: owner, holder: borrower.id,
                              users_with_direct_see_permission: [user_only_see_permissions])
    item_lent.waitlist = create(:waitlist, item: item_lent)
    item_lent.groups_with_lend_permission << lend_group
    item_lent
  end
  let(:item_private) do
    item_private = create(:item, owning_user: owner)
    item_private
  end

  it "shows edit button for owner" do
    sign_in owner
    visit item_path(item)
    expect(page).to have_link(href: edit_item_url(item, locale: RSpec.configuration.locale))
  end

  it "does not show edit button for non-owner" do
    sign_in user
    visit item_path(item)
    expect(page).not_to have_link(href: edit_item_url(item, locale: RSpec.configuration.locale))
  end

  it "shows edit button for group members, hides for others" do
    group = create(:group)
    member = group.owners[0]
    group_item = create(:item, owning_group: group)
    sign_in member
    visit item_path(group_item)
    expect(page).to have_link(href: edit_item_url(group_item, locale: RSpec.configuration.locale))
    sign_in user
    visit item_path(group_item)
    expect(page).not_to have_link(href: edit_item_url(group_item, locale: RSpec.configuration.locale))
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
    group_item = create(:item, owning_group: group, users_with_direct_see_permission: [user])
    sign_in user
    visit item_path(group_item)
    expect(page).to have_text(group.name)
    visit item_path(item)
    expect(page).not_to have_text(group.name)
  end

  it "renders an image" do
    sign_in user
    visit item_path(item)
    expect(page).to have_css("main img")
  end

  it "renders an image with a data url" do
    sign_in user
    visit item_path(item)
    expect(page).to have_css('main img[src^="data:"]')
  end

  it "has lend button when item is available and user has lend permission and not owner of item" do
    sign_in user
    visit item_path(item)
    expect(page).to have_button("Lend")
  end

  it "has disabled lend button when item is available and user has no lend permission and not owner of item" do
    sign_in user_only_see_permissions
    visit item_path(item)
    expect(page).to have_button("Lend", disabled: true)
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
    expect(page).to have_button("Waiting for return approval", disabled: true, class: "btn-secondary")
  end

  it "creates audit event when requesting for returning" do
    sign_in borrower
    visit item_path(item_lent)
    find(:button, "Return").click
    expect(AuditEvent.where(item_id: item_lent.id, event_type: "request_return",
                            triggering_user: borrower).count).to be(1)
  end

  it "has enter waitlist button when user has lend permission and is not on list and item not available" do
    sign_in user
    visit item_path(item_lent)
    expect(page).to have_button("Enter Waitlist")
  end

  it "has disabled enter waitlist button when user has no lend permission and is not on list and item not available" do
    sign_in user_only_see_permissions
    visit item_path(item_lent)
    expect(page).to have_button("Enter Waitlist", disabled: true, class: "btn-secondary")
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
    item_lent.users_with_direct_lend_permission << item_lent.waitlist.users[0]
    sign_in item_lent.waitlist.users[0]
    visit item_path(item_lent)
    find(:button, "Leave Waitlist").click
    notification = MoveUpOnWaitlistNotification.find_by(receiver: Item.find(item_lent.id).waitlist.users[0],
                                                        item: item_lent)
    expect(notification).not_to be_nil
  end

  it "does not display price when 0 or nil" do
    user = create(:user)
    item_without_price = create(:item_without_price, users_with_direct_see_permission: [user])
    sign_in user
    visit item_path(item_without_price)
    expect(page).not_to have_text("Price")
    item_price_zero = create(:item_price_zero, users_with_direct_see_permission: [user])
    visit item_path(item_price_zero)
    expect(page).not_to have_text("Price")
    item.users_with_direct_see_permission << user
    visit item_path(item)
    expect(page).to have_text(item.price_ct)
  end

  it "displays return checklist only if not empty" do
    item_empty_return_checklist = create(:item_empty_return_checklist)
    sign_in item_empty_return_checklist.owning_user
    visit item_path(item_empty_return_checklist)
    expect(page).not_to have_text("Return Checklist")

    sign_in user
    visit item_path(item)
    expect(page).to have_text(item.return_checklist)
  end

  it "displays lent until if lent" do
    sign_in borrower
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

  it "displays the add to favorites button" do
    sign_in user
    visit item_path(item)
    expect(page).to have_link(href: add_to_favorites_path(item, locale: RSpec.configuration.locale))
  end

  it "displays the leave favorites button when item is already a favorite" do
    user.favorites << (item)
    sign_in user
    visit item_path(item)
    expect(page).to have_link(href: leave_favorites_path(item, locale: RSpec.configuration.locale))
  end

  it "does not display favorites button in owner view" do
    sign_in owner
    visit item_path(item)
    expect(page).not_to have_link(href: add_to_favorites_path(item))
    expect(page).not_to have_link(href: leave_favorites_path(item))
    owner.favorites << (item)
    visit item_path(item)
    expect(page).not_to have_link(href: add_to_favorites_path(item))
    expect(page).not_to have_link(href: leave_favorites_path(item))
  end

  it "has a working add to favorites button" do
    sign_in user
    visit item_path(item)
    find(:link, href: add_to_favorites_path(item, locale: RSpec.configuration.locale)).click
    expect(user.favorites.exists?(item.id)).to be(true)
  end

  it "has a working leave favorites button" do
    user.favorites << (item)
    sign_in user
    visit item_path(item)
    find(:link, href: leave_favorites_path(item, locale: RSpec.configuration.locale)).click
    expect(user.favorites.exists?(item.id)).to be(false)
  end

  it "shows holder email for owner" do
    sign_in owner
    visit item_url(item_lent)
    expect(page).to have_text I18n.t("views.show_item.lent_by")
  end

  it "does not show holder email for non-owner" do
    sign_in user
    visit item_url(item_lent)
    expect(page).not_to have_text I18n.t("views.show_item.lent_by")
  end

  it "shows rental end when item lent" do
    sign_in user
    visit item_url(item_lent)
    expect(page).to have_text I18n.t("views.show_item.lent_until")
  end

  it "does not show rental end when item not lent" do
    sign_in user
    visit item_url(item)
    expect(page).not_to have_text I18n.t("views.show_item.lent_until")
  end

  it "renders without rental start and duration set" do
    sign_in user
    an_item = create(:item_without_time, waitlist: create(:waitlist_with_item), owning_user: user)
    visit item_url(an_item)
    expect(page).to have_text I18n.t("views.show_item.less_than_one_day")
  end

  it "shows correct maximum lending duration for non-owner" do
    sign_in user
    visit item_url(item_lent)
    expect(page).to have_text I18n.t("views.show_item.less_than_one_day")
    day = 86_400
    item_lent.update(rental_duration_sec: day)
    visit item_url(item_lent)
    expect(page).to have_text I18n.t("views.show_item.one_day")
    two_days = 2 * day
    item_lent.update(rental_duration_sec: two_days)
    visit item_url(item_lent)
    expect(page).to have_text I18n.t("views.show_item.less_than_days", days_amount: 3)
    week = 7 * day
    item_lent.update(rental_duration_sec: week)
    visit item_url(item_lent)
    expect(page).to have_text I18n.t("views.show_item.one_week")
    three_weeks = 3 * week
    item_lent.update(rental_duration_sec: three_weeks)
    visit item_url(item_lent)
    expect(page).to have_text I18n.t("views.show_item.less_than_weeks", weeks_amount: 4)
    month = 4 * week
    item_lent.update(rental_duration_sec: month)
    visit item_url(item_lent)
    expect(page).to have_text I18n.t("views.show_item.one_month")
    five_months = 5 * month
    item_lent.update(rental_duration_sec: five_months)
    visit item_url(item_lent)
    expect(page).to have_text I18n.t("views.show_item.less_than_months", months_amount: 6)
  end

  it "shows unauthorized if user does not have see permissions" do
    sign_in user
    visit item_url(item_private)
    expect(page.status_code).to eq(403)
  end

  it "shows average lend time statistic" do
    item_with_audit = create(:itemAudited0, owning_user: owner)
    sign_in owner

    create(:audit_event,
           item: item_with_audit,
           event_type: :accept_lend,
           created_at: Date.jd(0))
    create(:audit_event,
           item: item_with_audit,
           event_type: :accept_return,
           created_at: Date.jd(1))
    visit item_url(item_with_audit)
    expect(page).to have_text I18n.t("views.show_item.avg_lend_time")
    expect(page).to have_text "1 #{I18n.t('amount.day', count: 1)}"
  end

  it "doesn't shows average lend time statistic if it has never been lent" do
    item_with_audit = create(:item, owning_user: owner)
    sign_in owner
    visit item_url(item_with_audit)
    expect(page).not_to have_text I18n.t("views.show_item.avg_lend_time")
  end

  it "shows only relevant timeunits for average lend time statistic" do
    item_with_audit = create(:itemAudited0, owning_user: owner)
    sign_in owner

    create(:audit_event,
           item: item_with_audit,
           event_type: :accept_lend,
           created_at: Date.jd(0))
    create(:audit_event,
           item: item_with_audit,
           event_type: :accept_return,
           created_at: Date.jd(1))
    visit item_url(item_with_audit)
    expect(page).to have_text I18n.t("views.show_item.avg_lend_time")
    expect(page).to have_text "1 #{I18n.t('amount.day', count: 1)}"
    expect(page).not_to have_text I18n.t("amount.hour", count: 1)
    expect(page).not_to have_text I18n.t("amount.minute", count: 1)
    expect(page).not_to have_text I18n.t("amount.second", count: 1)
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers

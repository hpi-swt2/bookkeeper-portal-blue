require "rails_helper"

describe "Requests handling", type: :feature do
  let(:owner) { create(:max) }
  let(:borrower) { create(:peter) }
  let(:item) { create(:item, owning_user: owner, users_with_direct_lend_permission: [borrower]) }
  let(:lend_group) do
    lend_group = create(:group)
    lend_group
  end

  before do
    lend_group.members << borrower
    item.groups_with_lend_permission << lend_group
  end

  it "if borrower send a lend request, the item status changes to pending_lend_request" do
    sign_in borrower
    visit item_path(item)
    click_button('Lend')
    expect(item.reload.lend_status).to eq('pending_lend_request')
    expect(AuditEvent.where(item: item, event_type: "request_lend").count).to be(1)
  end

  it "if owner accepts lend request, the item lend status changes to pending_pickup" do
    sign_in borrower
    visit item_path(item)
    click_button('Lend')
    sign_in owner
    visit notifications_path
    click_on('Lend Request')
    click_button('Accept')
    expect(item.reload.lend_status).to eq('pending_pickup')
  end

  it "if borrower confirms pickup, the item lend status changes to lent" do
    sign_in borrower
    visit item_path(item)
    click_button('Lend')
    sign_in owner
    visit notifications_path
    click_on('Lend Request')
    click_button('Accept')
    sign_in borrower
    visit item_path(item)
    click_button('Confirm pickup')
    expect(item.reload.lend_status).to eq('lent')
    expect(AuditEvent.where(item: item, event_type: "accept_lend").count).to be(1)
  end

end

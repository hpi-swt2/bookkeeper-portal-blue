require "rails_helper"

describe "Requests handling", type: :feature do

  it "if borrower send a lend request, the item status changes to pending_lend_request" do
    owner = create(:max)
    borrower = create(:peter)
    item = create(:item, owning_user: owner)
    sign_in borrower
    visit item_path(item)
    click_button('Lend')
    expect(item.reload.lend_status).to eq('pending_lend_request')
    expect(AuditEvent.where(item: item, event_type: "request_lend").count).to be(1)
  end

  it "if owner accepts lend request, the item lend status changes to pending_pickup" do
    owner = create(:max)
    borrower = create(:peter)
    item = create(:item, owning_user: owner)
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
    owner = create(:max)
    borrower = create(:peter)
    item = create(:item, owning_user: owner)
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

require "rails_helper"

describe "Requests handling", type: :feature do

  it "owner can start lending by accepting the request and it creates audit events" do
    owner = create(:max)
    borrower = create(:peter)
    item = create(:item, owner: owner.id)
    sign_in borrower
    visit item_path(item)
    click_button('Lend')
    expect(item.reload.lend_status).to eq('pending_lend_request')
    expect(AuditEvent.where(item: item, event_type: "request_lend").count).to be(1)
    sign_in owner
    visit notifications_path
    click_button('Check')
    click_button('Accept')
    expect(item.reload.lend_status).to eq('lent')
    expect(AuditEvent.where(item: item, event_type: "accept_lend").count).to be(1)
  end
end

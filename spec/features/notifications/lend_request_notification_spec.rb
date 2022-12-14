require "rails_helper"

describe "Lend Request Notifications", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:borrower) { create(:max, password: password) }
  let(:item) { create(:item, owner: user.id) }

  before do
    sign_in user
    @notification = build(:lend_request_notification, user: user, item: item, borrower: borrower, active: true)
    @notification.save
  end

  it "has accept and decline buttons" do
    visit notification_path(id: @notification.id)
    expect(page).to have_button("Accept")
    expect(page).to have_button("Decline")
  end

  it "changes accepted to true when Accept is clicked" do
    visit notification_path(id: @notification.id)
    click_button('Accept')
    @notification.reload
    expect(@notification.active).to be false
    expect(@notification.accepted).to be true
  end

  it "changes accepted to false when Decline is clicked" do
    visit notification_path(id: @notification.id)
    click_button('Decline')
    @notification.reload
    expect(@notification.active).to be false
    expect(@notification.accepted).to be false
  end
end

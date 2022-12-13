require "rails_helper"

describe "Return Request Notifications", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:borrower) { create(:max, password: password) }
  let(:item) { create(:pending, owner: user.id) }

  before do
    sign_in user
    @notification = build(:return_request_notification, user: user, item: item, borrower: borrower, active: true)
    @notification.save
  end

  it "shows an accept and decline button" do
    print(Notification.all)
    visit notification_path(id: @notification.id)
    click_button("Check")
    expect(page).to have_button("Accept")
    expect(page).to have_button("Decline")
  end

  it "completes the lending process and change the item's status to available upon clicking on 'Accept'" do
    visit notification_path(id: @notification.id)

    expect(ReturnRequestNotification.exists?(@notification.id)).to be true
    expect(Item.find(@notification.item.id).lend_status).to eq 'pending_return'
    click_button('Accept')
    expect(Item.find(@notification.item.id).lend_status).to eq 'available'
    expect(ReturnRequestNotification.exists?(@notification.id)).to be false
  end

  it "deletes the notification upon clicking on 'Decline" do
    visit notification_path(id: @notification.id)
    expect(ReturnRequestNotification.exists?(@notification.id)).to be true
    click_button('Decline')
    expect(ReturnRequestNotification.exists?(@notification.id)).to be false
  end
end

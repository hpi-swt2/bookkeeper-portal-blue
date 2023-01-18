require "rails_helper"

describe "Return Request Notifications", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }

  before do
    sign_in user
    FactoryBot.reload
    @notification = build(:return_request_notification, receiver: user, active: true)
    @notification.item.waitlist = Waitlist.new
    @notification.save
  end

  it "shows an accept and decline button" do
    visit notifications_path(id: @notification.id)
    expect(page).to have_button("Accept")
    expect(page).to have_button("Decline")
  end

  it "completes the lending process and change the item's status to available upon clicking on 'Accept'" do
    visit notifications_path(id: @notification.id)

    expect(ReturnRequestNotification.exists?(@notification.id)).to be true
    expect(Item.find(@notification.item.id).lend_status).to eq 'pending_return'
    click_button('Accept')
    expect(Item.find(@notification.item.id).lend_status).to eq 'available'
    expect(ReturnRequestNotification.exists?(@notification.id)).to be false
  end

  it "creates an audit when completing the lending process by clicking on 'Accept'" do
    visit notifications_path

    click_button('Accept')
    expect(AuditEvent.where(item: @notification.item.id, event_type: "accept_return",
                            triggering_user: user).count).to be(1)
  end

  it "deletes the notification upon clicking on 'Decline'" do
    visit notifications_path(id: @notification.id)
    expect(ReturnRequestNotification.exists?(@notification.id)).to be true
    click_button('Decline')
    expect(ReturnRequestNotification.exists?(@notification.id)).to be false
  end

  it "sends a return accepted notification upon clicking on 'Accept'" do
    visit notifications_path(id: @notification.id)
    expect(ReturnRequestNotification.exists?(@notification.id)).to be true
    click_button('Accept')
    @accepted_notification = Notification.find_by(receiver: @notification.item.holder,
                                                  actable_type: "ReturnAcceptedNotification")
    expect(@accepted_notification.nil?).to be false
    expect(ReturnAcceptedNotification.exists?(id: @accepted_notification.actable_id,
                                              item: @notification.item)).to be true
  end

  it "sends a return denied notification upon clicking on 'Decline" do
    visit notifications_path(id: @notification.id)
    expect(ReturnRequestNotification.exists?(@notification.id)).to be true
    click_button('Decline')
    @declined_notification = Notification.find_by(receiver: @notification.item.holder,
                                                  actable_type: "ReturnDeclinedNotification")
    expect(@declined_notification.nil?).to be false
    expect(ReturnDeclinedNotification.exists?(id: @declined_notification.actable_id,
                                              item_name: @notification.item.name)).to be true

  end

  it "doesn't change to read when clicked" do
    visit notifications_path
    @notification.reload
    expect(@notification.unread).to be true
  end

end

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
  end

  it "creates an audit when completing the lending process by clicking on 'Accept'" do
    visit notifications_path

    click_button('Accept')
    expect(AuditEvent.where(item: @notification.item.id, event_type: "accept_return",
                            triggering_user: user).count).to be(1)
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
                                              item: @notification.item)).to be true

  end

  it "sends a lend request notification from the first user on the waitlist upon accepting the return of an item" do
    visit notifications_path(id: @notification.id)
    @max_hash = attributes_for(:max)
    create(:max) unless User.exists?(email: @max_hash[:email])

    @max = User.find_by(email: @max_hash[:email])
    @notification.item.waitlist = Waitlist.new
    @notification.item.waitlist.add_user(@max)
    @notification.item.waitlist.save

    expect(ReturnRequestNotification.exists?(@notification.id)).to be true
    click_button('Accept')
    @lend_notification = Notification.find_by(receiver: @notification.item.holder,
                                              actable_type: "LendRequestNotification")
    expect(@lend_notification.nil?).to be false
    expect(LendRequestNotification.exists?(id: @lend_notification.actable_id, borrower: @max)).to be true

  end

  it "doesn't change to read when clicked" do
    visit notifications_path
    @notification.reload
    expect(@notification.unread).to be true
  end

  it "sends an email after creation" do
    expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
  end
end

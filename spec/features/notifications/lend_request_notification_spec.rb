require "rails_helper"

describe "Lend Request Notifications", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:owner) { create(:max) }
  let(:borrower) { create(:peter) }
  let(:item) { create(:item, owning_user: user) }

  before do
    sign_in user
    @notification = build(:lend_request_notification, receiver: user, item: item, borrower: borrower, active: true)
    @notification.save
  end

  it "sends an email after creation" do
    expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
  end

  it "has accept and decline buttons" do
    visit notifications_path
    click_on('Lend Request')
    expect(page).to have_button("Accept")
    expect(page).to have_button("Decline")
  end

  it "changes accepted to true when Accept is clicked" do
    visit notifications_path
    click_on('Lend Request')
    click_button('Accept')
    @notification.reload
    expect(@notification.active).to be false
    expect(@notification.accepted).to be true
  end

  it "changes accepted to false when Decline is clicked" do
    visit notifications_path
    click_on('Lend Request')
    click_button('Decline')
    @notification.reload
    expect(@notification.active).to be false
    expect(@notification.accepted).to be false
  end

  it "can be for the same item" do
    visit notifications_path
    click_on('Lend Request')
    click_button('Decline')
    @notification.reload
    expect(@notification.active).to be false
    @notification2 = build(:lend_request_notification, receiver: user, item: item, borrower: user, active: true)
    @notification2.save
    visit notifications_path
    click_on('wants to borrow your')
    click_button('Decline')
    @notification2.reload
    expect(@notification2.active).to be false
  end

  it "user gets notified someone wants to lend his/her item" do
    item = create(:item, owning_user: owner)
    sign_in borrower
    visit item_path(item)
    click_button('Lend')
    sign_in owner
    visit notifications_path
    expect(page).to have_text(borrower.name)
    expect(page).to have_text(item.name)
  end

  it "borrower gets notified when the request is accepted" do
    visit notifications_path
    click_on('Lend Request')
    click_button('Accept')
    sign_in borrower
    visit notifications_path
    expect(page).to have_text(user.name)
    expect(page).to have_text(item.name)
    expect(page).to have_text('Lending Accepted')
  end

  it "borrower gets notified when the request is denied" do
    visit notifications_path
    click_on('Lend Request')
    click_button('Decline')
    sign_in borrower
    visit notifications_path
    expect(page).to have_text(user.name)
    expect(page).to have_text(item.name)
    expect(page).to have_text('Lending Denied')
  end

  it "doesn't change to read when clicked" do
    visit notifications_path
    click_on('Lend Request')
    @notification.reload
    expect(@notification.unread).to be true
  end

  it "does change to read when accepted" do
    visit notifications_path
    click_on('Lend Request')
    click_button('Accept')
    @notification.reload
    expect(@notification.unread).to be false
  end

  it "does change to read when declined" do
    visit notifications_path
    click_on('Lend Request')
    click_button('Decline')
    @notification.reload
    expect(@notification.unread).to be false
  end
end
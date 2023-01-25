require "rails_helper"

describe "Move Up On Waitlist Notifications", type: :feature do
  let(:password) { 'password' }
  let(:receiver) { build(:user, password: password) }

  before do
    sign_in receiver
    FactoryBot.reload
    @notification = build(:move_up_on_waitlist_notification, receiver: receiver, active: true)
    @notification.item.waitlist = build(:empty_waitlist)
  end

  it "sends an email after creation if position is zero" do
    @notification.item.waitlist.users << receiver
    @notification.save
    expect(@notification.item.waitlist.position(receiver)).to eq 0
    expect(ActionMailer::Base.deliveries.last.to).to eq [receiver.email]
  end

  it "sends no email after creation if position is non zero" do
    @notification.item.waitlist.users << build(:max, password: password)
    @notification.item.waitlist.users << receiver
    @notification.save
    expect(ActionMailer::Base.deliveries).to be_empty
  end
end

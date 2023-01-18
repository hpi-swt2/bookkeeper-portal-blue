require "rails_helper"

describe "Move Up On Waitlist Notifications", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }

  before do
    sign_in user
    FactoryBot.reload
    @notification = build(:move_up_on_waitlist_notification, receiver: user, active: true)
    @notification.item.waitlist = Waitlist.new
    @notification.save
  end

  it "sends an email after creation" do
     expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
  end
end

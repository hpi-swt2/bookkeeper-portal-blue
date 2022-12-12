require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { build(:lend_request_notification) }

  it "can be created using a factory" do
    expect(notification).to be_valid
  end

  it "has a date and user" do
    expect(notification.date).not_to be_blank
    expect(notification.user).not_to be_blank
  end

  it "has a factory that returns a list of different notifications" do
    user = build(:user)
    notification_list = build_list(:notification, 2, user: user)
    expect(notification_list.length).to eq(2)
    expect(notification_list[0].user).to eq(notification_list[1].user)
    expect(notification_list[0]).not_to eq(notification_list[1])
  end

end

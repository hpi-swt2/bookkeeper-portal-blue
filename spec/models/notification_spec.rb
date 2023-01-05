require 'rails_helper'

RSpec.describe Notification, type: :model do
  before do
    @notification = build(:notification)
  end

  it "can NOT be created without using some subclass" do
    expect(described_class.new).not_to be_valid
  end

  it "can parse the current time" do
    time = DateTime.current
    @notification.date = time
    expect(@notification.parse_time).to eq time.strftime("%H:%M")
  end

  it "can parse the time of yesterday" do
    time = DateTime.current - 1.day
    @notification.date = time
    expect(@notification.parse_time).to eq "Yesterday"
  end

  it "can parse the time of the last week" do
    time = DateTime.current - 6.days
    @notification.date = time
    expect(@notification.parse_time).to eq time.strftime("%A")
  end

  it "can parse the time more than 6 days ago" do
    time = DateTime.current - 7.days
    @notification.date = time
    expect(@notification.parse_time).to eq time.strftime("%d/%m/%Y")
  end
end

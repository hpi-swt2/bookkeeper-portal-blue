require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { build(:notification) }

  it "can be created using a factory" do
    expect(notification).to be_valid
  end

  it "should have a date and user" do
    expect(notification.date).not_to be_blank
    expect(notification.user).not_to be_blank
  end
  
end

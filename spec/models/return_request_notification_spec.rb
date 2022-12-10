require 'rails_helper'

RSpec.describe ReturnRequestNotification, type: :model do
  let(:notification) { build(:return_request_notification) }
  let(:invalid_notification) { build(:invalid_return_request_notification) }

  it "can be created using a factory" do
    expect(notification).to be_valid
  end

  it 'should not be valid when the user and/or date is missing' do
    expect(invalid_notification).to_not be_valid
  end
end

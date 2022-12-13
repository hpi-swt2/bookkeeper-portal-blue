require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { build(:lend_request_notification) }

  it "can be created using a factory" do
    expect(notification).to be_valid
  end

  it "can NOT be created without using some subclass" do
    expect(described_class.new).not_to be_valid
  end

end

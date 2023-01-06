require 'rails_helper'

RSpec.describe Notification, type: :model do

  it "can NOT be created without using some subclass" do
    expect(described_class.new).not_to be_valid
  end

end

require 'rails_helper'

RSpec.describe Notification, type: :model do

  it "can NOT be created without using some subclass" do
    expect(Notification.new).not_to be_valid
  end

end

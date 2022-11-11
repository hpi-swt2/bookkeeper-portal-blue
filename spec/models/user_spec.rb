require 'rails_helper'

describe User, type: :model do
  let(:user) { FactoryBot.build :user }

  it "can be created using a factory" do
    expect(user).to be_valid
  end

  it "has an email attribute" do
    expect(user.email).not_to be_blank
  end
end

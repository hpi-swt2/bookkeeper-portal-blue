require 'rails_helper'

describe User, type: :model do
  let(:user) { build(:max) }

  it "can be created using a factory" do
    expect(user).to be_valid
  end

  it "has an email attribute" do
    expect(user.email).not_to be_blank
  end

  it "has a first name" do
    expect(user.first_name).not_to be_blank
  end

  it "has a last name" do
    expect(user.last_name).not_to be_blank
  end

  it "has a full name" do
    expect(user.name).not_to be_blank
  end
end

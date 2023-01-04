require 'rails_helper'

RSpec.describe AuditEvent, type: :model do

  before do
    @user = create(:user)
    @item = create(:item)
  end

  it "is valid with all required attributes" do
    item = described_class.new(item: @item, owner: @user, holder: @user, triggering_user: @user,
                               event_type: "create_item")
    expect(item).to be_valid
  end

  it "is not valid without item" do
    item = described_class.new(owner: @user, holder: @user, triggering_user: @user, event_type: "create_item")
    expect(item).not_to be_valid
  end

  it "is not valid without owner" do
    item = described_class.new(item: @item, holder: @user, triggering_user: @user, event_type: "create_item")
    expect(item).not_to be_valid
  end

  it "is valid without holder" do
    item = described_class.new(item: @item, owner: @user, triggering_user: @user, event_type: "create_item")
    expect(item).to be_valid
  end

  it "is not valid without triggering_user" do
    item = described_class.new(item: @item, owner: @user, holder: @user, event_type: "create_item")
    expect(item).not_to be_valid
  end

  it "is not valid without event_type" do
    item = described_class.new(item: @item, owner: @user, holder: @user, triggering_user: @user)
    expect(item).not_to be_valid
  end

end

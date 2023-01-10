require 'rails_helper'

RSpec.describe AuditEvent, type: :model do

  before do
    @user = create(:user)
    @item = create(:item)
  end

  it "is valid with all required attributes" do
    audit_event = described_class.new(item: @item, owner: @user, holder: @user, triggering_user: @user,
                                      event_type: "create_item")
    expect(audit_event).to be_valid
  end

  it "is not valid without item" do
    audit_event = described_class.new(owner: @user, holder: @user, triggering_user: @user, event_type: "create_item")
    expect(audit_event).not_to be_valid
  end

  it "is not valid without owner" do
    audit_event = described_class.new(item: @item, holder: @user, triggering_user: @user, event_type: "create_item")
    expect(audit_event).not_to be_valid
  end

  it "is valid without holder" do
    audit_event = described_class.new(item: @item, owner: @user, triggering_user: @user, event_type: "create_item")
    expect(audit_event).to be_valid
  end

  it "is not valid without triggering_user" do
    audit_event = described_class.new(item: @item, owner: @user, holder: @user, event_type: "create_item")
    expect(audit_event).not_to be_valid
  end

  it "is not valid without event_type" do
    audit_event = described_class.new(item: @item, owner: @user, holder: @user, triggering_user: @user)
    expect(audit_event).not_to be_valid
  end

end

require 'rails_helper'

RSpec.describe ReminderNotificationJob, type: :job do

  it "changes the item's status to available if the pickup time has passed" do
    item = create(:item)
    holder = create(:user)
    item.holder = holder.id
    item.lend_status = 'pending_pickup'
    item.save
    expect(item.reload.lend_status).to eq('pending_pickup')
    described_class.perform_now(item)
    expect(item.reload.lend_status).to eq('available')
  end

  it "the holder is set to nil after job" do
    item = create(:item)
    holder = create(:user)
    item.holder = holder.id
    item.lend_status = 'pending_pickup'
    item.save
    expect(item.reload.lend_status).to eq('pending_pickup')
    described_class.perform_now(item)
    expect(item.reload.holder).to be_nil
  end

end

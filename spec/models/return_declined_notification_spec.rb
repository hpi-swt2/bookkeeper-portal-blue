require 'rails_helper'

RSpec.describe ReturnDeclinedNotification, type: :model do

  let(:notification) { build(:return_declined_notification) }
  let(:invalid_notification) { build(:invalid_return_declined_notification) }

  it "is creatable via a factory" do
    expect(notification).to be_valid
  end

  it 'is not valid when the receiver and/or date is missing' do
    expect(invalid_notification).not_to be_valid
  end

  it "belongs to a receiver, a date, an item name and a owner" do
    expect(notification.receiver).not_to be_blank
    expect(notification.item).not_to be_blank
    expect(notification.date).not_to be_blank
  end

  it "has differently translated title and description" do
    title, description = ""
    I18n.with_locale(:en) do
      title = notification.title
      description = notification.description
    end
    I18n.with_locale(:de) do
      expect(notification.title).not_to eq title
      expect(notification.description).not_to eq description
    end
  end
end

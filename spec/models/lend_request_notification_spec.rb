require 'rails_helper'

RSpec.describe LendRequestNotification, type: :model do

  let(:notification) { create(:lend_request_notification) }

  it "should be creatable via a factory" do
    expect(notification).to be_valid
  end

  it "should belong to a user, a date, an item and a borrower" do
    expect(notification.user).not_to be_blank
    expect(notification.item).not_to be_blank
    expect(notification.borrower).not_to be_blank
    expect(notification.date).not_to be_blank
  end

  it "should have differently translated title and description" do
    I18n.locale = :en
    en_title = notification.title
    en_description = notification.description
    I18n.locale = :de
    de_title = notification.title
    de_description = notification.description
    expect(en_title).not_to eq de_title
    expect(en_description).not_to eq de_description
  end

end

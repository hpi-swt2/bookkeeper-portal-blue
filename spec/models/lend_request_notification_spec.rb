require 'rails_helper'

RSpec.describe LendRequestNotification, type: :model do

  let(:notification) { create(:lend_request_notification) }

  it "is creatable via a factory" do
    expect(notification).to be_valid
  end

  it "belongs to a user, a date, an item and a borrower" do
    expect(notification.user).not_to be_blank
    expect(notification.item).not_to be_blank
    expect(notification.borrower).not_to be_blank
    expect(notification.date).not_to be_blank
  end

  it "has differently translated title and description" do
    I18n.with_locale = :en
    en_title = notification.title
    en_description = notification.description
    I18n.with_locale = :de
    de_title = notification.title
    de_description = notification.description
    expect(en_title).not_to eq de_title
    expect(en_description).not_to eq de_description
  end

end

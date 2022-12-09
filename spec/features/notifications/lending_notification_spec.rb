require "rails_helper"

describe "Lending Notifications Page", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }

  before do
    sign_in user
    FactoryBot.reload
    @notifications = create_list(:lend_request_notification, 5, user: user)
    @notifications.each(&:save)
    visit("#{notifications_path}/#{@notifications[0].id}")
  end

  it "displays the description, title and picture of the notification" do
    expect(page).to have_text(@notifications[0].description)
    expect(page).to have_text(@notifications[0].title)
  end

  it "has buttons to accept and decline" do
    expect(page).to have_button(I18n.t("defaults.accept"))
    expect(page).to have_button(I18n.t("defaults.decline"))
  end

  it "has a back button" do
    expect(page).to have_link "", href: notifications_path
  end

end

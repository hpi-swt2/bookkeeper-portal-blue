require "rails_helper"

describe "Notifications Page", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }

  before do
    sign_in user
    FactoryBot.reload
    @notifications = create_list(:lend_request_notification, 5, user: user)
    @notifications.each(&:save)
  end

  it "cannot be reached when not logged in and displays error" do
    sign_out user
    visit notifications_path
    expect(page).to have_css('.alert-danger')
    expect(page).not_to have_current_path(notifications_path)
  end

  it "can be reached when logged in" do
    visit notifications_path
    expect(page).to have_current_path(notifications_path)
  end

  it "displays the notifications of the current user with text" do
    visit notifications_path
    @notifications.each do |notification|
      expect(page).to have_text(notification.description)
    end
  end

  it "is clickable" do
    visit notifications_path
    expect{find('.notification', text: @notifications[0].description).click}.not_to raise_error
  end

end

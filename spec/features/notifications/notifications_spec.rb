require "rails_helper"

describe "Notifications Page", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }

  before do
    sign_in user
    FactoryBot.reload
    @notifications = create_list(:notification, 5, user: user)
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

  it "is scrollable" do
    pending("find out how to test, maybe just test that bar is always is always there")
    raise
  end

  it "displays the notifications of the current user with text" do
    visit notifications_path
    @notifications.each do |notification|
      expect(page).to have_text(notification.notification_snippet)
    end
  end

  it "is grouped by date" do
    same_day_notifications = create_list(:notification, 2, user: user, date: DateTime.now)
    same_day_notifications.each(&:save)
    visit notifications_path
    @notifications.each do |notification|
      expect(page).to have_text(notification.date.strftime("%d.%B %y"))
    end
  end

  it "is clickable" do
    visit notifications_path
    expect(page).to have_link @notifications[0].notification_snippet
  end

end

require "rails_helper"

describe "Notifications Page", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:borrower) { create(:max, password: password) }
  let(:item) { create(:item, owner: user.id) }

  before do
    sign_in user
    FactoryBot.reload
    # need to use some subclass of notification
    # because notifications are "abstract"
    @notifications = create_list(:lend_request_notification, 5, receiver: user, item: item, borrower: borrower)
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
      expect(page).to have_text(notification.title)
      expect(page).to have_text(notification.description)
    end
  end

  it "is grouped by date" do
    same_day_notifications = create_list(:lend_request_notification, 2, receiver: user, borrower: borrower, item: item,
                                                                        date: DateTime.now)
    same_day_notifications.each(&:save)
    visit notifications_path
    @notifications.each do |notification|
      expect(page).to have_text(notification.date.strftime("%d. %B %y"))
    end
  end

end

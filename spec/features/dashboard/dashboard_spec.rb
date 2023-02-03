require "rails_helper"

RSpec.describe "Dashboard", type: :feature do

  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:borrower) { create(:max, password: password) }
  let(:item) { create(:item, owning_user: user) }

  it "redirects to login without user signed in" do
    visit dashboard_path
    expect(page).to have_current_path(new_user_session_path)
  end

  it "shows the user name" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(@user.first_name)
  end

  it "links to notifications" do
    sign_in user
    visit dashboard_path
    expect(page).to have_link(href: notifications_path(locale: I18n.locale))
  end

  it "shows unread messages when there are none" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.unread_messages', count: 0)
  end

  it "shows the correct number of unread messages" do
    sign_in user
    @notifications = create_list(:lend_request_notification, 2, receiver: user, item: item, borrower: borrower,
                                                                active: true)
    @notifications.each(&:save)
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.unread_messages', count: 2)
  end

  it "shows lent items" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.lent_items.title')
  end

  it "shows offered items" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.offered_items.title')
  end

  it "shows what items you are waiting for" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.waitlist.title')
  end

  it "shows favorites" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.favorites.title')
  end
end

require "rails_helper"

RSpec.describe "Dashboard", type: :feature do

  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:borrower) { create(:max, password: password) }
  let(:item) { create(:item, owner: user.id) }

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

  it "shows unread messages and links to notifications" do
    sign_in user
    visit dashboard_path
    expect(page).to have_link(href: '/notifications')
    expect(page).to have_content I18n.t('views.dashboard.unread_messages', count: 0)
    @notifications = create_list(:lend_request_notification, 2, receiver: user, item: item, borrower: borrower,
                                                                active: true)
    @notifications.each(&:save)
    page.refresh
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

  it "shows message when nothing is offered" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.offered_items.nothing_offered')
  end

  it "shows offered item" do
    @user = create(:user)
    item = create(:item, owner: @user.id)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
  end

  it "shows wishlist" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.wishlist.title')
  end

  it "shows wishlist item" do
    @user = create(:user)
    item = create(:item)
    @user.wishlist << (item)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
  end

  it "shows message when wishlist is empty" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.wishlist.missing_wishlist')
  end

  it "shows the correct tag for available wishlist items" do
    @user = create(:user)
    item = create(:item)
    @user.wishlist << (item)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.wishlist.available')
  end

  it "shows the correct tag for unavailable wishlist items" do
    @user = create(:user)
    @holder = create(:user)
    item = create(:item, holder: @holder.id)
    @user.wishlist << (item)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.wishlist.not_available')
  end

  it "shows the correct tag for lend wishlist items" do
    @user = create(:user)
    item = create(:item, holder: @user.id)
    @user.wishlist << (item)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.wishlist.lent_by_you')
  end

  it "displays the progess as 0 if the rental start is in the future" do
    @user = create(:user)
    @holder = create(:user)
    item = create(:item, holder: @holder.id, rental_start: Time.now.utc + 1.day)
    expect(item.progress_lent_time).to equal(0)
  end
end

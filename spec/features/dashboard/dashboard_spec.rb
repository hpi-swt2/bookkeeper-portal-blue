require "rails_helper"

RSpec.describe "Dashboard", type: :feature do

  let(:user) { build(:user) }

  it "renders without user signed in" do
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.not_signed_in')
  end

  it "shows the user name" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content("User")
  end

  it "shows unread messages" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.unread_messages')
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
    expect(page).to have_content I18n.t('views.dashboard.wishlist.lend_by_you')
  end
end

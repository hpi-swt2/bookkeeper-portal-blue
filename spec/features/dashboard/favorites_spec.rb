require "rails_helper"

RSpec.describe "Favorites", type: :feature do

  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:item) { create(:item, owning_user: user) }

  it "shows favorites item" do
    @user = create(:user)
    item = create(:item)
    @user.favorites << (item)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
  end

  it "shows message when favorites is empty" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.favorites.missing_favorites')
  end

  it "shows the correct tag for available favorites items" do
    @user = create(:user)
    item = create(:item)
    @user.favorites << (item)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.favorites.available')
  end

  it "shows the correct tag for unavailable favorites items" do
    @user = create(:user)
    @holder = create(:user)
    item = create(:item, holder: @holder.id)
    @user.favorites << (item)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.favorites.not_available')
  end

  it "shows the correct tag for lend favorites items" do
    @user = create(:user)
    item = create(:item, holder: @user.id)
    @user.favorites << (item)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.favorites.lent_by_you')
  end
end

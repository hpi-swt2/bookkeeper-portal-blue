require "rails_helper"

RSpec.describe "Progress Bar under Lent items", type: :feature do

  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:item) { create(:item, owning_user: user) }

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
end

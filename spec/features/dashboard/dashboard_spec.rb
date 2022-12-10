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
    expect(page).to have_content("User1")
  end

  it "shows unread messages" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.unread_messages')
  end

  it "shows lent items" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.lent_items')
  end

  it "shows offered items" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.offered_items')
  end

  it "shows message when nothing is offered" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.nothing_offered')
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
    expect(page).to have_content I18n.t('views.dashboard.your_wishlist')
  end
end

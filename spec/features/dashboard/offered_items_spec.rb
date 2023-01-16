require "rails_helper"

RSpec.describe "Offered Items", type: :feature do

  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:item) { create(:item, owning_user: user) }

  it "shows message when nothing is offered" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.offered_items.nothing_offered')
  end

  it "shows offered item" do
    @user = create(:user)
    item = create(:item, owning_user: @user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
  end

  it "shows the correct tag for offered items which are not lent out" do
    @user = create(:user)
    item = create(:item, owning_user: @user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(page).to have_content I18n.t('views.dashboard.offered_items.not_lent')
  end

  it "shows the correct tag for offered items which are lent out by someone else" do
    @user = create(:user)
    @borrower = create(:user)
    item = create(:item, owning_user: @user, holder: @borrower.id)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(page).to have_content I18n.t('views.dashboard.offered_items.lent')
  end

  it "shows the correct tag for offered items lent out by yourself" do
    @user = create(:user)
    item = create(:item, owning_user: @user, holder: @user.id)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(page).to have_content I18n.t('views.dashboard.offered_items.lent_by_you')
  end

  it "shows the correct tag for offered items which are overdue" do
    @user = create(:user)
    @borrower = create(:user)
    item = create(:item, owning_user: @user, holder: @borrower.id, rental_start: Time.now.utc - 10.seconds,
                         rental_duration_sec: 5)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(page).to have_content I18n.t('views.dashboard.offered_items.overdue')
  end
end

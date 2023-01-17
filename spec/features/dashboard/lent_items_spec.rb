require "rails_helper"

RSpec.describe "Lent Items", type: :feature do

  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:item) { create(:item, owning_user: user) }

  it "shows message when nothing is lent out" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.lent_items.no_lent_items')
  end

  it "shows lent item" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
  end

  it "shows the correct tag for lent items which are not overdue" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id, rental_start: Time.now.utc,
                         rental_duration_sec: 86_400)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(page).to have_content I18n.t('views.dashboard.lent_items.today')
  end

  it "shows the correct tag for lent items which are overdue" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id, rental_start: Time.now.utc - 10.seconds,
                         rental_duration_sec: 5)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(page).to have_content I18n.t('views.dashboard.lent_items.expired',
                                        date: item.rental_end.strftime("%d.%m.%Y"))
  end
end

require "rails_helper"

RSpec.describe "Progress Bar under Lent items", type: :feature do

  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:item) { create(:item, owning_user: user) }

  it "displays the progess as 0 if the rental start is in the future" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id, rental_start: Time.now.utc + 1.day)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(find('div.progress-bar')['aria-valuenow']).to eq('0%')
  end

  it "displays the progess as 0 if the rental start is now" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id, rental_start: Time.now.utc, rental_duration_sec: 86_400)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(find('div.progress-bar')['aria-valuenow']).to eq('0%')
  end

  it "displays the progess as 100 if the remaining rental duration is zero" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id, rental_duration_sec: 0)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(find('div.progress-bar')['aria-valuenow']).to eq('100%')
  end

  it "displays the progess as 50 if the remaining rental duration is half of the original rental duration" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id, rental_duration_sec: 172_800,
                         rental_start: Time.now.utc - 1.day)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(find('div.progress-bar')['aria-valuenow']).to eq('50%')
  end

  it "displays the progess as 100 if the rental start is nil" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id, rental_start: nil)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(find('div.progress-bar')['aria-valuenow']).to eq('100%')
  end

  it "displays the progess as 100 if the remaining rental duration is nil" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id, rental_duration_sec: nil)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(find('div.progress-bar')['aria-valuenow']).to eq('100%')
  end

  it "displays the progess as 0 if the rental duration is unlimited" do
    @owner = create(:user)
    @user = create(:user)
    item = create(:item, owning_user: @owner, holder: @user.id, rental_duration_unit: 'Unlimited',
                         rental_duration_sec: 60.years.to_i)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
    expect(find('div.progress-bar')['aria-valuenow']).to eq('0%')
  end
end

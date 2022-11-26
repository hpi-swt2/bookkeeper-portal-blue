require "rails_helper"

describe "Navigation Bar", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }

  it "is viewable after login" do
    sign_in user
    visit root_path
    expect(page).to have_css('.bk-nav')
  end

  it "is not viewable before login" do
    visit root_path
    expect(page).not_to have_css('.bk-nav')
  end

  it "has a link to dashboard" do
    sign_in user
    visit root_path
    expect(page).to have_link(href: dashboard_path)
  end

  it "has a link to search" do
    sign_in user
    visit root_path
    expect(page).to have_link(href: search_path)
  end

  it "has a link to new item" do
    sign_in user
    visit root_path
    expect(page).to have_link(href: new_item_path)
  end

  it "has a link to notifications" do
    sign_in user
    visit root_path
    expect(page).to have_link(href: notifications_path)
  end

  it "has a link to profile" do
    sign_in user
    visit root_path
    expect(page).to have_link(href: profile_path)
  end
end

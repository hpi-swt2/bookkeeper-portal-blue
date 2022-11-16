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
end

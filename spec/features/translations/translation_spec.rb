require "rails_helper"

describe "Translations", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }

  it "displays correct title on dashboard in English by default" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content("Dashboard")
  end

  it "displays correct title on dashboard in German when requested" do
    sign_in user
    visit dashboard_path({ locale: 'de' })
    expect(page).to have_content("Übersicht")
  end

  it "displays correct title on dashboard in English when an invalid locale is requested" do
    sign_in user
    visit dashboard_path({ locale: 'zh' })
    expect(page).to have_content("Dashboard")
  end
end

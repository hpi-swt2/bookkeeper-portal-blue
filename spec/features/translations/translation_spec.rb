require "rails_helper"

describe "Translations", type: :feature do

  it "displays correct title on homepage in English by default" do
    visit root_path
    expect(page).to have_text("Bookkeeper Blue")
  end

  it "displays correct title on homepage in German when requested" do
    page.driver.header 'Accept-language', 'de-DE'
    visit root_path
    expect(page).to have_text("Bookkeeper Blau")
  end

  it "displays correct title on homepage in English when an invalid locale is requested" do
    page.driver.header 'Accept-language', 'pt-PT'
    visit root_path
    expect(page).to have_text("Bookkeeper Blue")
  end
end
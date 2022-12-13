require "rails_helper"

describe "Translations", type: :feature do

  it "displays correct title on dashboard in English by default" do
    visit dashboard_path
    expect(page.title).to eq("Bookkeeper Blue")
  end

  it "displays correct title on dashboard in German when requested" do
    page.driver.header 'Accept-language', 'de-DE'
    visit dashboard_path
    expect(page.title).to eq("Bookkeeper Blau")
  end

  it "displays correct title on dashboard in English when an invalid locale is requested" do
    page.driver.header 'Accept-language', 'pt-PT'
    visit dashboard_path
    expect(page.title).to eq("Bookkeeper Blue")
  end
end

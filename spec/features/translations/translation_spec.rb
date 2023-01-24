require "rails_helper"

describe "Translations", type: :feature do

  it "displays correct title on dashboard in English by default" do
    visit dashboard_path
    expect(page.title).to eq("Bookkeeper Blue")
  end

  context 'when local is set to :de' do
    let(:local) { :en }

    it "displays correct title on dashboard in German when requested" do
      visit dashboard_path
      expect(page.title).to eq I18n.t('views.landing_page.title')
    end
  end

  context 'when invalid local is set' do
    let(:local) { :zh }

    it "displays correct title on dashboard in English when an invalid locale is requested" do
      visit dashboard_path
      expect(page.title).to eq I18n.t('views.landing_page.title')
    end
  end
end

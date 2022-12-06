require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  it "renders without rental start and duration set" do
    an_item = create(:item_without_time)
    visit item_url(an_item)
    expect(page).to have_text(Time.zone.now.advance(days: 1).strftime('%d.%m.%Y'))
  end
end
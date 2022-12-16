require "rails_helper"

describe "Return Request Notifications", type: :feature do

  it "user gets notified someone wants to lend his/her item" do
    owner = FactoryBot.create(:max)
    borrower = FactoryBot.create(:peter)
    item = FactoryBot.create(:item, owner: owner.id)
    sign_in borrower   
    visit item_path(item)   
    click_button('Lend')
    sign_in owner
    visit notifications_path
    expect(page).to have_text(borrower.name)
    expect(page).to have_text(item.name)
  end
end

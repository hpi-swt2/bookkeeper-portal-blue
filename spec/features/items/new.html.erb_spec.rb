require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  it "preselects the user that is logged in" do
    sign_in user1
    visit(new_item_url)
    expect(page).to have_select "item_owner_id", selected: user1.email
    sign_in user2
    visit(new_item_url)
    expect(page).to have_select "item_owner_id", selected: user2.email
  end

  it "only has the option to select the current user" do
    sign_in user1
    visit(new_item_url)
    expect(page).to have_select "item_owner_id", options: [user1.email]
    sign_in user2
    visit(new_item_url)
    expect(page).to have_select "item_owner_id", options: [user2.email]
  end

  it "has the option to select groups that the user is a member of" do
    group = create(:group)
    create(:group)
    member = group.owners[0]
    sign_in member
    visit(new_item_url)
    expect(page).to have_select "item_owner_id", options: [member.email, group.name], selected: member.email
    sign_in user1
    visit(new_item_url)
    expect(page).to have_select "item_owner_id", options: [user1.email]
  end
end

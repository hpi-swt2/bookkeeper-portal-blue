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
    # to check if only 'group' that the user is a member of is shown
    # in the dropdown, a second group is created
    create(:group)
    member = group.owners[0]
    sign_in member
    visit(new_item_url)
    expect(page).to have_select "item_owner_id", options: [member.email, group.name], selected: member.email
    sign_in user1
    visit(new_item_url)
    expect(page).to have_select "item_owner_id", options: [user1.email]
  end

  it "displays owner selection in alphabetical order" do
    group3 = create(:group, name: "C Group 3")
    group1 = create(:group, name: "A Group 1")
    group2 = create(:group, name: "B Group 2")

    user = create(:user)

    user.to_owner_of!(group1)
    user.to_owner_of!(group2)
    user.to_owner_of!(group3)

    user.save

    sign_in user
    visit new_item_url
    expect(find('#item_owner_id option:nth-child(1)')).to have_content(user.email)
    expect(find('#item_owner_id option:nth-child(2)')).to have_content(group1.name)
    expect(find('#item_owner_id option:nth-child(3)')).to have_content(group2.name)
    expect(find('#item_owner_id option:nth-child(4)')).to have_content(group3.name)
  end

  it "displays lend permission selection in alphabetical order" do
    group3 = create(:group, name: "C Group 3")
    group1 = create(:group, name: "A Group 1")
    group2 = create(:group, name: "B Group 2")

    user = create(:user)
    sign_in user
    visit new_item_url
    expect(find('#item_lend_group_ids option:nth-child(1)')).to have_content(group1.name)
    expect(find('#item_lend_group_ids option:nth-child(2)')).to have_content(group2.name)
    expect(find('#item_lend_group_ids option:nth-child(3)')).to have_content(group3.name)
  end

  it "displays see permission selection in alphabetical order" do
    group3 = create(:group, name: "C Group 3")
    group1 = create(:group, name: "A Group 1")
    group2 = create(:group, name: "B Group 2")

    user = create(:user)
    sign_in user
    visit new_item_url
    expect(find('#item_see_group_ids option:nth-child(1)')).to have_content(group1.name)
    expect(find('#item_see_group_ids option:nth-child(2)')).to have_content(group2.name)
    expect(find('#item_see_group_ids option:nth-child(3)')).to have_content(group3.name)
  end
end

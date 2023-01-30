require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  it "preselects the owning user or group" do
    group = create(:group)
    # to check if only 'group' that the user is a member of is shown
    # in the dropdown, a second group is created
    create(:group)
    member = group.owners[0]
    group_item = create(:item, owning_group: group)
    user_item = create(:item, owning_user: member)
    sign_in member
    visit edit_item_url(group_item)
    expect(page).to have_select "item_owner_id", options: [member.email, group.name], selected: group.name
    visit edit_item_url(user_item)
    expect(page).to have_select "item_owner_id", options: [member.email, group.name], selected: member.email
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
    item = create(:item, owning_user: user)
    visit edit_item_url(item)
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
    item = create(:item, owning_user: user)
    visit edit_item_url(item)
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
    item = create(:item, owning_user: user)
    visit edit_item_url(item)
    expect(find('#item_see_group_ids option:nth-child(1)')).to have_content(group1.name)
    expect(find('#item_see_group_ids option:nth-child(2)')).to have_content(group2.name)
    expect(find('#item_see_group_ids option:nth-child(3)')).to have_content(group3.name)
  end
end

RSpec.describe "Groups", type: :feature do
  let(:group) { create(:group) }

  it "allows users to create groups" do
    sign_in create(:user)
    visit new_group_path
    fill_in "group_name", with: "Test Group"
    click_button "Add Group"
    expect(page).to have_text("Test Group")
  end

  it "shows the group name" do
    sign_in group.owners.first
    visit group_path(group)
    expect(page).to have_text(group.name)
  end

  it "shows the owners" do
    sign_in group.owners.first
    visit group_path(group)
    expect(find_by_id('group-owners')).to have_text(group.owners.first.name)
  end

  it "shows the members" do
    user = create(:user)
    group.members.append(user)
    sign_in user
    visit group_path(group)
    expect(find_by_id('group-members')).to have_text(user.name)
  end

  it "shows the owners not in the members list" do
    sign_in group.owners.first
    visit group_path(group)
    expect(find_by_id('group-members')).not_to have_text(group.owners.first.name)
  end

  it "allows owners to add members" do
    user = create(:user)
    sign_in group.owners.first
    visit group_path(group)
    select user.email, from: "user_id"
    click_button "Add member"
    expect(find_by_id('group-members')).to have_text(user.name)
  end

  it "does not allow members to add members" do
    user = create(:user)
    group.members.append(user)
    sign_in user
    visit group_path(group)
    expect(page).not_to have_select("user_id")
  end

  it "shows demote buttons if current user is owner" do
    sign_in group.owners.first
    visit group_path(group)

    group.owners.each do |owner|
      expect(page).to have_link("Remove owner",
                                href: group_demote_path(group, owner, locale: RSpec.configuration.locale))
    end
  end

  it "shows promote buttons if current user is owner" do
    group.members << create(:max)
    sign_in group.owners.first
    visit group_path(group)

    group.members_without_ownership.each do |member|
      expect(page).to have_link("Make owner",
                                href: group_promote_path(group, member, locale: RSpec.configuration.locale))
    end
  end

  it "does not show demote buttons if current user is not owner" do
    member = create(:max)
    group.members << member
    sign_in member
    visit group_path(group)

    expect(page).not_to have_link("Remove owner")
  end

  it "does not show promote buttons if current user is not owner" do
    member = create(:max)
    group.members << member
    sign_in member
    visit group_path(group)

    expect(page).not_to have_link("Make owner")
  end

  it "promotes members to owners on button click" do
    member = create(:max)
    group.members << member
    sign_in group.owners.first
    visit group_path(group)

    find(:link, "Make owner", href: group_promote_path(group, member, locale: RSpec.configuration.locale)).click

    group.reload

    expect(group.owners).to include(member)
  end

  it "demotes owners to members on button click" do
    owner = create(:max)
    group.owners << owner
    sign_in group.owners.first
    visit group_path(group)

    find(:link, "Remove owner", href: group_demote_path(group, owner, locale: RSpec.configuration.locale)).click

    group.reload

    expect(group.owners).not_to include(owner)
    expect(group.members).to include(owner)
  end

  it "shows remove buttons if current user is owner" do
    owner = create(:max)
    sign_in owner
    group.owners << owner
    visit group_path(group)

    group.members_without_ownership.each do |member|
      expect(page).to have_link("Remove from group", href: group_remove_path(group, member))
    end
  end

  it "does not show remove buttons if current user is not owner" do
    member = create(:max)
    group.members << member
    sign_in member
    visit group_path(group)

    expect(page).not_to have_link("Remove from group")
  end

  it "removes members from group on button click" do
    member = create(:max)
    group.members << member
    sign_in group.owners.first
    visit group_path(group)

    find(:link, "Remove from group", href: group_remove_path(group, member, locale: RSpec.configuration.locale)).click

    group.reload

    expect(group.members).not_to include(member)
  end

  it "creates a notification when a user is removed from a group" do
    member = create(:max)
    group.members << member
    sign_in group.owners.first
    visit group_path(group)

    find(:link, "Remove from group", href: group_remove_path(group, member, locale: RSpec.configuration.locale)).click

    expect(Notification.count).to eq(1)
    notification = Notification.first
    expect(notification.receiver).to eq(member)
    expect(notification.description).to include(group.name)
  end

  it "does not add normal users to the HPI group" do
    user = create(:user)
    sign_in user
    expect(user.groups).not_to include(Group.default_hpi)
  end

  it "adds OIDC users to the HPI group" do
    oidc_user = create(:peter)
    OmniAuth.config.mock_auth[:openid_connect] = OmniAuth::AuthHash.new(
      provider: "openid_connect",
      uid: "peter.lustig",
      info: {
        email: oidc_user.email
      }
    )

    visit new_user_session_path
    find_by_id('openid_connect-signin').click
    expect(oidc_user.groups).to include(Group.default_hpi)
  end

  it "shows leave button if current user is member" do
    sign_in group.members.first
    visit group_path(group)
    expect(page).to have_link("Leave group", href: group_leave_path(group, locale: RSpec.configuration.locale))
  end

  it "does not show leave button if current user is not member" do
    sign_in create(:user)
    visit group_path(group)

    expect(page).not_to have_link("Leave group", href: group_leave_path(group, locale: RSpec.configuration.locale))
  end

  it "removes a user if they leave" do
    user = group.members.first
    sign_in user
    visit group_path(group)
    click_link "Leave group"

    expect(group.members).not_to include(user)
  end

  it "does not crash when the same user signs in again with OIDC" do
    oidc_user = create(:peter)
    OmniAuth.config.mock_auth[:openid_connect] = OmniAuth::AuthHash.new(
      provider: "openid_connect",
      uid: "peter.lustig",
      info: {
        email: oidc_user.email
      }
    )

    visit new_user_session_path
    find_by_id('openid_connect-signin').click
    visit profile_path
    click_on('logout')
    visit new_user_session_path
    find_by_id('openid_connect-signin').click
    visit profile_path
    expect(oidc_user.groups).to include(Group.default_hpi)
  end

  it 'sorts the users in the groups view alphabetically by email' do
    user2 = create(:user, email: 'c@d.com')
    user3 = create(:user, email: 'x@y.com')
    user1 = create(:user, email: 'a@b.com')

    sign_in group.owners.first
    visit group_path(group)
    expect(find('#user_id option:nth-child(1)')).to have_content(user1.email)
    expect(find('#user_id option:nth-child(2)')).to have_content(user2.email)
    expect(find('#user_id option:nth-child(3)')).to have_content(user3.email)
  end
end

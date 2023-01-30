RSpec.describe "Profile", type: :feature do

  let(:user) { build(:max) }
  let(:group) { build(:group) }

  it "redirects to login without user signed in" do
    visit profile_path
    expect(page).to have_current_path(new_user_session_path)
  end

  it "shows the user name" do
    sign_in user
    visit profile_path
    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
  end

  it "shows email address" do
    sign_in user
    visit profile_path
    expect(page).to have_content I18n.t('views.profile.email')
  end

  it "shows the user email" do
    sign_in user
    visit profile_path
    expect(page).to have_text(user.email)
  end

  it "shows groups" do
    sign_in user
    visit profile_path
    expect(page).to have_content I18n.t('views.profile.groups')
  end

  it "has an edit profile button" do
    sign_in user
    visit profile_path
    expect(page).to have_link(href: edit_user_registration_path(locale: RSpec.configuration.locale))
  end

  it "has a logout button" do
    sign_in user
    visit profile_path
    expect(page).to have_link(href: destroy_user_session_path(locale: RSpec.configuration.locale))
  end

  it "has a logout button which redirects to the login page" do
    sign_in user
    visit profile_path
    click_on('logout')
    expect(page).to have_current_path(new_user_session_path(locale: RSpec.configuration.locale))
  end

  it "has a logout button which ends the current session" do
    sign_in user
    visit profile_path
    click_on('logout')
    visit dashboard_path
    expect(page).to have_current_path(new_user_session_path)
  end

  it "has a create group button" do
    sign_in user
    visit profile_path
    expect(page).to have_link 'Add Group', href: new_group_path(locale: RSpec.configuration.locale)
  end

  it "displays the user's groups when member" do
    user.groups.append(group)
    user.save
    sign_in user
    visit profile_path
    expect(page).to have_text(group.name)
  end

  it "displays the user's owned groups" do
    user.owned_groups.append(group)
    user.save
    sign_in user
    visit profile_path
    expect(page).to have_text(group.name)
  end

  it "displays a message when in no groups" do
    sign_in user
    visit profile_path
    expect(page).to have_text("Not member of any group")
  end

  it "displays groups in alphabetical order" do
    group3 = build(:group, name: "C Group 3")
    group1 = build(:group, name: "A Group 1")
    group2 = build(:group, name: "B Group 2")


    user.groups.append(group1)
    user.groups.append(group2)
    user.groups.append(group3)

    user.save

    sign_in user
    visit profile_path
    expect(find('#groups li:nth-child(1)')).to have_content(group1.name)
    expect(find('#groups li:nth-child(2)')).to have_content(group2.name)
    expect(find('#groups li:nth-child(3)')).to have_content(group3.name)
  end
end

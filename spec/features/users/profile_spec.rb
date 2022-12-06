RSpec.describe "Profile", type: :feature do

  let(:user) { build(:max) }

  it "shows the user name" do
    sign_in user
    visit profile_path
    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
  end

  it "shows roles" do
    sign_in user
    visit profile_path
    expect(page).to have_content I18n.t('views.profile.roles')
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
    expect(page).to have_link 'Profil bearbeiten', href: edit_user_registration_path
  end
end

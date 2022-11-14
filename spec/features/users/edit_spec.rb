require "rails_helper"

describe "User Edit Page", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }

  it "cannot be reached when not logged in and displays error" do
    visit edit_user_registration_path
    expect(page).to have_css('.alert-danger')
    expect(page).not_to have_current_path(edit_user_registration_path)
  end

  it "is viewable after login" do
    sign_in user
    visit edit_user_registration_path
    expect(page).not_to have_css('.alert-danger')
    expect(page).to have_current_path(edit_user_registration_path)
  end

  it "displays the current email and allows updating it" do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_field('user[email]', with: user.email)

    new_mail = "#{user.email}_new"
    fill_in 'user[email]', with: new_mail
    # Need to enter current password to make changes to user
    fill_in 'user[current_password]', with: password
    page.find('input[type=submit]').click
    expect(user.reload.email).to eq(new_mail)
  end
end

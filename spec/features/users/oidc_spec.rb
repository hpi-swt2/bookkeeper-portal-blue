# frozen_string_literal: true

require "rails_helper"

describe "OpenId Connect Login", type: :feature do
  context "with a valid OIDC session returned" do
    before do
      OmniAuth.config.mock_auth[:openid_connect] = OmniAuth::AuthHash.new(
        provider: "openid_connect",
        uid: "test.user",
        info: {
          email: "test.user@hpi.de"
        }
      )

      visit new_user_session_path
      find_by_id('openid_connect-signin').click
    end

    it "redirects to dashboard path" do
      expect(page).to have_current_path(dashboard_path)
    end

    it "displays a success message" do
      expect(page).to have_css(".alert-success")
    end
  end

  context "with invalid oidc session returned" do
    before do
      @omniauth_logger = OmniAuth.config.logger
      # Change OmniAuth logger (default output to STDOUT)
      OmniAuth.config.logger = Rails.logger

      OmniAuth.config.mock_auth[:openid_connect] = :invalid_credentials
      visit new_user_session_path
      find_by_id('openid_connect-signin').click
    end

    it "redirects to login path" do
      expect(page).to have_current_path(new_user_session_path)
    end

    it "shows an error message" do
      expect(page).to have_css(".alert-danger")
    end

  end
end

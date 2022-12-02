require 'rails_helper'

RSpec.describe "Profile", type: :request do
  describe "GET /index" do
    let(:user) { build(:max) }

    it "returns http success" do
      sign_in user
      get "/profile"
      expect(response).to have_http_status(:success)
    end
  end

end

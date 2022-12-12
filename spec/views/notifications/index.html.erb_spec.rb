require 'rails_helper'

RSpec.describe "notifications/index", type: :view do
  before do
    assign(:notifications, create_list(:lend_request_notification, 2))
  end
end

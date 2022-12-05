require 'rails_helper'

RSpec.describe Group, type: :model do

  before do
    @group = create(:group)
  end

  it "can be created using a factory" do
    expect(@group).to be_valid
  end
end

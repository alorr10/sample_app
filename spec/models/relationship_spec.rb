require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  it "is valid from factory" do
    r = FactoryGirl.create(:relationship, follower_id: user.id, followed_id: user2.id)
    expect(r).to be_valid
  end

  it "should require a follower_id" do
    r = FactoryGirl.create(:relationship, follower_id: user.id, followed_id: user2.id)
    r.follower_id = nil
    expect(r).to_not be_valid
  end

  it "should require a followed_id" do
    r = FactoryGirl.create(:relationship, follower_id: user.id, followed_id: user2.id)
    r.followed_id = nil
    expect(r).to_not be_valid
  end
end

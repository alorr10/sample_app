require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user)         { FactoryGirl.create(:user_with_microposts) }
  let(:post)         { FactoryGirl.create(:micropost) }
  let(:current_post) { FactoryGirl.create(:micropost, :most_recent) }

  it "is valid" do
    expect(post.valid?).to be true
  end

  it "cant have nil user_id" do
    post.user_id = nil
    expect(post.valid?).to be false
  end

  it "cant have nil content" do
    post.content = "   "
    expect(post.valid?).to be false
  end

  it "cant have more than 140 characters" do
    post.content = "a"*141
    expect(post.valid?).to be false
  end

  it "should show the most recent post first" do
    expect(user.microposts.first.created_at).to eq(current_post.created_at)
  end
end

require 'rails_helper'

RSpec.describe "Feeds", type: :request do

  let(:user) { FactoryGirl.create(:user_with_microposts) }
  let(:user2) { FactoryGirl.create(:user_with_microposts) }
  let(:user3) { FactoryGirl.create(:user_with_microposts) }

  describe "GET /feeds" do
    it "contains correct info" do
      user.follow!(user2)

      # Posts from followed user
      user2.microposts.each do |m|
        expect(user.feed.include?(m)).to be true
      end

      # Posts from self
      user.microposts.each do |m|
        expect(user.feed.include?(m)).to be true
      end

      # Posts from unfollowed user
      user3.microposts.each do |m|
        expect(user.feed.include?(m)).to be false
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Followings", type: :request do

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:user3) { FactoryGirl.create(:user) }
  let(:r) { FactoryGirl.create(:relationship) }

  def log_in_as(user, remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: remember_me } }
  end

  describe "Followings" do

    before(:each) do
      log_in_as(user)
    end
    it "verifies following page is good" do
      #log_in_as(user)
      user.follow!(user2)
      user.follow!(user3)
      get following_user_path(user)
      expect(user.following.empty?).to be false
      expect(response.body).to match user.following.count.to_s
      user.following.each do |u|
        expect(response.body).to include(user_path(u))
      end
    end

    it "verifies followers page is good" do
      #log_in_as(user)
      user2.follow!(user)
      user3.follow!(user)
      get followers_user_path(user)
      expect(user.followers.empty?).to be false
      expect(response.body).to match user.followers.count.to_s
      user.followers.each do |u|
        expect(response.body).to include(user_path(u))
      end
    end

    it "should follow a user the standard way" do
      before_count = Relationship.count
      post relationships_path, params: { followed_id: user2.id }
      after_count  = Relationship.count
      expect(before_count).to_not eq after_count
    end

    it "should follow a user with Ajax" do
      before_count = Relationship.count
      post relationships_path, xhr: true, params: { followed_id: user2.id }
      after_count  = Relationship.count
      expect(before_count).to_not eq after_count
    end

    it "should unfollow a user the standard way" do
      user.follow!(user2)
      before_count = Relationship.count
      relationship = user.active_relationships.find_by(followed_id: user2.id)
      delete relationship_path(relationship)
      after_count  = Relationship.count
      expect(before_count).to_not eq after_count
    end

    it "should unfollow a user with Ajax" do
      user.follow!(user2)
      before_count = Relationship.count
      relationship = user.active_relationships.find_by(followed_id: user2.id)
      delete relationship_path(relationship), xhr: true
      after_count  = Relationship.count
      expect(before_count).to_not eq after_count
    end
  end

  describe "GET relationships" do
    it "create requires a logged in user" do
      before_count = Relationship.count
      post relationships_path
      after_count  = Relationship.count
      expect(before_count).to eq after_count
      expect(response).to redirect_to(login_url)
    end

    it "destroy requires a logged in user" do
      re = FactoryGirl.create(:relationship, follower_id: user.id, followed_id: user2.id)
      before_count = Relationship.count
      delete relationship_path(re)
      after_count  = Relationship.count
      expect(before_count).to eq after_count
      expect(response).to redirect_to(login_url)
    end
  end
end





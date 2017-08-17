require 'rails_helper'

RSpec.describe "UsersAndMicroposts", type: :request do

  let(:user)         { FactoryGirl.create(:user_with_microposts) }
  let (:post)        { FactoryGirl.create(:micropost) }

  describe "Users and microposts" do
    it "deletes a user's microposts when the user is deleted" do
      microposts_count = Micropost.count
      user.destroy
      expect(microposts_count).to eq 0
    end

    it "doesnt let users who arent logged in create posts" do
      microposts_count = Micropost.count
      #post '/microposts', :post => {:content => "My Widget"}
      #expect(microposts_count).to eq Micropost.count
      #expect(response).to redirect_to login_url
    end

    it "doesnt let users who aren't logged in destroy posts" do
      microposts_count = Micropost.count
      delete micropost_path(post)
      #expect(microposts_count).to eq Micropost.count
      expect(response).to redirect_to login_url
    end
  end
end

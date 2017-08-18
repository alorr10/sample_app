require 'rails_helper'

RSpec.describe "MicropostsInterfaces", type: :request do

  let(:user) { FactoryGirl.create(:user_with_microposts) }
  let(:other_user) { FactoryGirl.create(:user_with_microposts) }
  let(:third_user) { FactoryGirl.create(:user) }

  def log_in_as(user, remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: remember_me } }
  end


  describe "GET /microposts_interfaces" do
    it "works! (now write some real specs)" do
      log_in_as(user)
      #other_user.microposts.create!(content: "Hi")
      delete micropost_path(other_user.microposts.first)
      expect(response).to redirect_to root_url
    end

    it "deletes a user's microposts when the user is deleted" do
      microposts_count = Micropost.count
      user.destroy
      expect(microposts_count).to eq 0
    end

    it "doesnt let users who arent logged in create posts" do
      microposts_count = Micropost.count
      post microposts_path, params: { micropost: { content: "Hi" } }
      expect(response).to redirect_to login_url
    end

    it "doesnt let users who aren't logged in destroy posts" do
      delete micropost_path(user.microposts.first)
      expect(response).to redirect_to login_url
    end

    it "should redirect destroy for wrong micropost" do
      log_in_as(user)
      delete micropost_path(other_user.microposts.first)
      expect(response).to redirect_to root_url
    end
  end

  describe "micropost interface" do
    it "creates microposts the right way" do
      log_in_as(user)
      get root_path
      expect(response.body).to match /div class="pagination"/im
      expect(response.body).to match /input accept="image\/jpeg, image\/gif, image\/png" type="file"/im

      # Invalid submission
      count = Micropost.count
      post microposts_path, params: { micropost: { content: "" } }
      expect(Micropost.count).to eq count
      expect(response.body).to match /div id="error_explanation"/im

      # Valid submission
      content = "This micropost really ties the room together"
      count = Micropost.count
      post microposts_path, params: { micropost: { content: content } }
      expect(Micropost.count).to_not eq count
      expect(response).to redirect_to root_url
      get root_url
      expect(response.body).to match content

      # Delete post
      expect(response.body).to match /data-method="delete"/im
      first_micropost = user.microposts.paginate(page: 1).first
      count = Micropost.count
      delete micropost_path(first_micropost)
      expect(Micropost.count).to_not eq count

      # Visit different user (no delete links)
      get user_path(other_user)
      expect(response.body).to_not include "data-method=delete"
    end

    it "has the right info" do
      log_in_as(user)
      get root_path
      expect(response.body).to match "#{user.microposts.count} microposts"

      # User with zero microposts
      log_in_as(third_user)
      get root_path
      expect(response.body).to match /0 microposts/
      third_user.microposts.create!(content: "A micropost")
      get root_path
      expect(response.body).to match "1 micropost"
    end
  end
end

require 'rails_helper'

RSpec.describe "UsersProfiles", type: :request do

  let(:user)         { FactoryGirl.create(:user_with_microposts) }

  describe "GET /users_profiles" do
    it "Render's the profile right" do
      get user_path(user)
      expect(response).to render_template('users/show')
      expect(response.body).to include (user.name)
      expect(response.body).to include ('class="gravatar"')
      expect(response.body).to match user.microposts.count.to_s
      expect(response.body).to include ('<div class="pagination"')
    end
  end
end

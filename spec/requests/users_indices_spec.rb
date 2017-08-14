require 'rails_helper'

RSpec.describe "UsersIndices", type: :request do

  def log_in_as(user, remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: remember_me } }
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:admin_user) { FactoryGirl.create(:user, :admin) }

  describe "GET /users_indices" do
    it "paginates" do
      create_list(:user, 31)
      log_in_as(user)
      get users_path
      expect(response).to render_template('users/index')
      expect(response.body).to include('div class="pagination')
      User.paginate(page: 1).each do |u|
        expect(response.body).to include(user_path(u))
      end
    end
  end

  describe "deleting a user" do
    it "redirects to login path if not logged in user tries to destroy" do
      user = FactoryGirl.create(:user)
      before_count = User.count
      delete(user_path(user))
      after_count = User.count
      expect(after_count).to eq before_count
      expect(response).to redirect_to(login_url)
    end

    it "should redirect destroy when logged in as a non-admin" do
      log_in_as(user)
      before_count = User.count
      delete user_path(user)
      after_count = User.count
      expect(after_count).to eq before_count
      expect(response).to redirect_to(root_url)
    end

    it "lets admins delete users" do
      log_in_as(admin_user)
      user = FactoryGirl.create(:user)
      before_count = User.count
      delete user_path(user)
      after_count = User.count
      expect(after_count).to eq (before_count-1)
      expect(response).to redirect_to('/users')
    end
  end
end

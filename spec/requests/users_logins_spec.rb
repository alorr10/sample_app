require 'rails_helper'

RSpec.describe "UserLogin", type: :request do
  let(:user) { FactoryGirl.create(:user) }

  describe "GET /login" do
    it "only shows flash error message once" do
      get login_path
      expect(response).to render_template(:new)
      post login_path, params: { session: { email: "", password: "" } }
      expect(response).to render_template(:new)
      expect(flash[:danger]).to be
      get root_path
      expect(flash[:danger]).to_not be
    end

    it "logs user in with valid info" do
      get login_path
      post login_path, params: {session: { email: user.email,
                                           password:
                                           user.password } }
      expect(response).to have_http_status(302)
      delete logout_path
      follow_redirect!
      assert_select "a[href=?]", login_path
    end
  end
end

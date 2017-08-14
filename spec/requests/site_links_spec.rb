require 'rails_helper'

RSpec.describe "SiteLinks", type: :request do

  let(:user) { FactoryGirl.create(:user) }

  def log_in_as(user, remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: remember_me } }
  end

  def log_out_as(user)
    delete logout_path
  end
  describe "GET /site_links" do
    it "lets logged_in user access links" do
      get root_path
      expect(response).to have_http_status(200)
      log_in_as(user)
      get user_path(user)
      expect(response).to have_http_status(200)
      get edit_user_path(user)
      expect(response).to have_http_status(200)
    end
  end
end
#get edit_user_path(user)
#expect(response).to redirect_to login_path
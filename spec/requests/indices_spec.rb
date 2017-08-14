require 'rails_helper'

RSpec.describe "Indices", type: :request do
  describe "GET /index" do
    it "redirects to root if not logged in" do
      get users_path
      expect(response).to redirect_to login_path
    end
  end
end

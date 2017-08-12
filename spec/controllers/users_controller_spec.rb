require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
end

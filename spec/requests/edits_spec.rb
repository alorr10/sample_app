require 'rails_helper'

RSpec.describe "Edits", type: :request do
  let(:user) { FactoryGirl.create(:user) }
  describe "GET /edit" do
    it "works! (now write some real specs)" do
      get edit_user_path(user)
      expect(response).to render_template(:edit)
      patch user_path(user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
      expect(response).to render_template(:edit)
    end
  end
end

require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do

  let(:r) { FactoryGirl.create(:relationship) }

  describe "GET relationships" do
    it "create requires a logged in user" do
      before_count = Relationship.count
      post :create
      after_count  = Relationship.count
      expect(before_count).to equal after_count
      expect(response).to redirect_to(login_url)
    end
  end
end
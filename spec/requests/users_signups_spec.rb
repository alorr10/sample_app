require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  describe "GET /users_signups" do
    it "invalid signup information" do
      get signup_path
      before_count = User.count
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
      after_count  = User.count
      expect(before_count).to equal after_count
      assert_template 'users/new'
    end

    it "accepts a valid signup" do
      before_count = User.count
      user = FactoryGirl.create(:user)
      post users_path, params: {user: { name:  user.name,
                                         email: user.email,
                                         password:              user.password,
                                         password_confirmation: user.password } }
      expect(before_count).to_not equal User.count
    end
  end
end

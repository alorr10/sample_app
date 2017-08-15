require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do

  before(:all) do
    ActionMailer::Base.deliveries.clear
  end

  def log_in_as(user, remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: remember_me } }
  end

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
      expect(response).to render_template('users/new')
    end

    it "accepts a valid signup" do
      before_count = User.count
      user = FactoryGirl.create(:user, :not_activated)
      post users_path, params: {user: { name:  user.name,
                                         email: user.email,
                                         password:              user.password,
                                         password_confirmation: user.password } }
      expect(before_count).to_not equal User.count
      user.send_activation_email
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(user.activated?).to eq false

      #Try to log in before activation.
      log_in_as(user)
      expect(is_logged_in?).to eq false

      # Invalid activation token
      get edit_account_activation_path("invalid token", email: user.email)
      expect(is_logged_in?).to eq false

      # Valid token, wrong email
      get edit_account_activation_path(user.activation_token, email: 'wrong')
      expect(is_logged_in?).to eq false

      # Valid activation token
      get edit_account_activation_path(user.activation_token, email: user.email)
      expect(user.reload.activated?).to eq true
      expect(response).to redirect_to(user_path(user))
      expect(is_logged_in?).to eq true
    end
  end
end

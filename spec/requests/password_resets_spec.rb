require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  before(:all) do
    ActionMailer::Base.deliveries.clear
  end

  describe "GET /password_resets" do
    it "works" do

      user = FactoryGirl.create(:user, :reset_token)
      get new_password_reset_path
      expect(response).to render_template('password_resets/new')

      #Invalid emails
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(flash[:danger]).to be
      expect(response).to render_template('password_resets/new')

      #Valid email
      post password_resets_path, params: { password_reset: { email: user.email } }
      expect(user.reset_digest).to_not eq (user.reload.reset_digest)
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(flash[:info]).to be
      expect(response).to redirect_to(root_url)

      #Wrong email
      get edit_password_reset_path(user.reset_token, email: "")
      expect(response).to redirect_to(root_url)

      #Inactive user
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to redirect_to(root_url)
      user.toggle!(:activated)

      #Right email, wrong token
      get edit_password_reset_path('wrong token', email: user.email)
      expect(response).to redirect_to(root_url)

      #Right email, right token
      user.update_attribute(:reset_digest, User.digest(user.reset_token))
      user.reload
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to render_template('password_resets/edit')
      expect(response.body).to match /input type="hidden" name="email" id="email" value="#{user.email}"/im

      #invalid password
      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
      expect(response.body).to match /div id="error_explanation"/im

      # Valid password & confirmation
      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
      expect(is_logged_in?).to be true
      expect(flash[:success]).to be
      expect(response).to redirect_to(user)
    end

    it "tests expired tokens" do
      user = FactoryGirl.create(:user, :reset_token)
      get new_password_reset_path
      post password_resets_path, params: { password_reset: { email: user.email } }
      user.update_attribute(:reset_sent_at, 3.days.ago)
      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
      expect(response).to redirect_to(root_url)
      #expect(response.body).to match /expired/im
    end
  end
end

require 'rails_helper'

RSpec.describe "Edits", type: :request do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  def log_in_as(user, remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: remember_me } }
  end
  describe "GET /edit" do
    it "doesnt update user with bad params" do
      log_in_as(user)
      get edit_user_path(user)
      expect(response).to render_template(:edit)
      patch user_path(user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
      expect(response).to render_template(:edit)
    end
    it "updates user info successfully" do
      log_in_as(user)
      get edit_user_path(user)
      expect(response).to render_template(:edit)
      new_name = "John Doe"
      new_email = "johnd@example.com"
      patch user_path(user), params: { user: { name:  new_name,
                                              email: new_email,
                                              password:              "",
                                              password_confirmation: "" } }
      expect(flash[:success]).to be
      expect(response).to redirect_to user_path
      user.reload
      expect(user.name).to eq new_name
      expect(user.email).to eq new_email
    end

    it "redirects home if a user isnt logged in" do
      get edit_user_path(other_user)
      expect(flash[:danger]).to be
      expect(response).to redirect_to login_path
    end

    it "should redirect update when not logged in" do
      patch user_path(other_user), params: { user: { name: other_user.name,
                                              email: other_user.email } }
      expect(flash[:danger]).to be
      expect(response).to redirect_to login_path
    end

    it "should redirect home if a user tries to access another user's edit page" do
      log_in_as(other_user)
      get edit_user_path(user)
      expect(flash[:danger]).to_not be
      expect(response).to redirect_to root_path
    end

    it "should redirect home if a user tries to update another user's info" do
      log_in_as(other_user)
      patch user_path(user), params: { user: { name: other_user.name,
                                              email: other_user.email } }
      expect(flash[:danger]).to_not be
      expect(response).to redirect_to root_path
    end

    it "successful goes to edit with friendly forwarding" do
      get edit_user_path(user)
      log_in_as(user)
      expect(response).to redirect_to edit_user_url(user)
      name  = "Foo Bar"
      email = "foo@bar.com"
      patch user_path(user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
      expect(flash[:danger]).to_not be
      expect(response).to redirect_to user_path
      user.reload
      expect(name).to eq user.name
      expect(email).to eq user.email
    end

    it "only friendly forwards once" do
      get edit_user_path(user)
      log_in_as(user)
      expect(response).to redirect_to edit_user_url(user)
      expect(session[:forwarding_url]).to_not be
    end
  end

  describe "updating values" do
    it "Doesnt allow admin attribute to be edited via the web" do
      log_in_as(user)
      expect(other_user.admin?).to be false
      patch user_path(other_user), params: {
                                    user: { password:              "foobar",
                                            password_confirmation: "foobar",
                                            admin: true } }
      expect(other_user.admin?).to be false
    end
  end
end


























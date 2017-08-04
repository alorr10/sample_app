require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  @base_title = "Ruby on Rails Tutorial Sample App"
  render_views

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
      expect(response.body).to match /<title>Home | #{@base_title}<\/title>/im
    end
  end

  describe "GET #help" do
    it "returns http success" do
      get :help
      expect(response).to have_http_status(:success)
      expect(response.body).to match /<title>Help | #{@base_title}<\/title>/im
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
      expect(response.body).to match /<title>About | #{@base_title}<\/title>/im
    end
  end

  describe "GET #contact" do
    it "returns http success" do
      get :contact
      expect(response).to have_http_status(:success)
      expect(response.body).to match /<title>Contact | #{@base_title}<\/title>/im
    end
  end

end

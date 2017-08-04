require 'rails_helper'

@root_path = '/'

RSpec.describe "SiteLayouts", type: :request do
  describe "GET Home" do
    it "works! (now write some real specs)" do
      get root_path
      expect(response).to have_http_status(200)
      assert_template 'static_pages/home'
      assert_select "a[href=?]", root_path, count: 2
      assert_select "a[href=?]", help_path
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path
      assert_select "a[href=?]", signup_path
    end
  end
end

require 'rails_helper'

@root_path = '/'

RSpec.describe "SiteLayouts", type: :request do
  describe "GET Home" do
    it "has all the required links" do
      get root_path
      expect(response).to have_http_status(200)
      expect(response).to render_template root_path
      expect(response.body).to include(help_path)
      expect(response.body).to include(about_path)
      expect(response.body).to include(contact_path)
      expect(response.body).to include(root_path)
    end
  end
end

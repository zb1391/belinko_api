require 'spec_helper'


describe Api::V1::OmniauthCallbacksController do
  before(:each) { request.headers['Accept'] = "application/vnd.belinko.v1" }
  
  describe "POST #facebook" do
    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      auth = OmniAuth.config.mock_auth[:facebook]
      auth.credentials = { :token => (User.count+1).to_s+"-token" }
      request.env["omniauth.auth"] = auth
      post :facebook, format: :json 
    end

    it "responds with a 201" do
      expect(response.status).to eql 201
    end
  end

end

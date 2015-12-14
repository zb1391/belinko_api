require 'spec_helper'

# set OmniAuth in test mode
OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
  :provider => 'facebook',
  :uid => '123545',
  :info => {
    :email => 'test@test.com'
  }
})

describe Api::V1::OmniauthCallbacksController do
  before(:each) { request.headers['Accept'] = "application/vnd.belinko.v1" }
  
  describe "POST #facebook" do
    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      post :facebook, format: :json 
    end

    it "responds with a 201" do
      expect(response.status).to eql 201
    end
  end

end

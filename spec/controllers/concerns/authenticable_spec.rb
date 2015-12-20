require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user, :auth_token => "test-auth-token"
      request.headers["Authorization"] = @user.auth_token
      authentication.stub(:request).and_return(request)
    end
    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
  end

  describe "#authenticate_with_token" do
    before do
      @user = FactoryGirl.create :user, :auth_token => "test-auth-token"
      authentication.stub(:current_user).and_return(nil)
      response.stub(:response_code).and_return(401)
      response.stub(:body).and_return({"errors" => "Not authenticated"}.to_json)
      authentication.stub(:response).and_return(response)
    end

    it "render a json error message" do
      expect(json_response[:errors]).to eql "Not authenticated"
    end

    it "responds with a 401" do
      expect(response.response_code).to eql 401
    end    

  end
end

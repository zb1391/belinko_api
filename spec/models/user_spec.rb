require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:uid) }
  it { should respond_to(:provider) }
  it { should respond_to(:auth_token) }

  it { should be_valid }

  describe "when the email is invalid" do
    before do
      @user.email = " "
    end

    it "should not be valid" do
      expect(@user.valid?).to eq(false)
    end
  end

  describe "User.from_omniauth" do
    before(:each) do
      @user = FactoryGirl.create :user, uid: "123", provider: "facebook"
      @auth = OmniAuth.config.mock_auth[:facebook]
      @auth.credentials = { :token => (User.count+1).to_s+"-token" }
      @auth.uid = "123"
    end

    it "returns the user when the auth params match" do
      expect(User.from_omniauth(@auth)).to eq @user
    end
  end

  describe "update_auth_token" do
    before(:each) do
      @user = FactoryGirl.create :user, auth_token: (User.count+1).to_s+'-token'
      @auth = OmniAuth.config.mock_auth[:facebook]
      @auth.credentials = { :token => (User.count+1).to_s+"-token-unique" }
      @auth.uid = "123"
      @user.update_auth_token(@auth.credentials.token)
    end

    it "updates the token when it differs from the current" do
      expect(@user.auth_token).to eql (User.count+1).to_s+"-token-unique"
    end 
  end
end

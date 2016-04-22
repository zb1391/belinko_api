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
  it { should respond_to(:name) }
  it { should respond_to(:thumbnail) }

  it { should be_valid }

  it { should have_many(:reviews) }
  it { should have_many(:places) }
  it { should have_many(:friendships) }
  it { should have_many(:friends) }

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


  describe "review associations" do
    before do
      @user = FactoryGirl.create :user, uid: "456", provider: "facebook"
      @place = FactoryGirl.create :place
      3.times { FactoryGirl.create :review, user: @user, place: @place }
    end

    it "destroys the associated reviews when the user is destroyed" do
      reviews = @user.reviews
      @user.destroy
      reviews.each do |review|
        expect(Review.find(review)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "#add_friends" do
    before do
      @user = FactoryGirl.create :user, uid: "999", provider: "facebook"
      @friend = FactoryGirl.create :user, uid: "142319996168495", provider: "facebook"
      @user.add_friends("fake_token")
    end

    it "creates a friendship record" do
      expect(@user.friends.count).to eql(1)
    end

    it "has the friend be @friend" do
      expect(@user.friends.first).to eql(@friend)
    end
  end
end

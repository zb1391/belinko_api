require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when the email is invalid" do
    before do
      @user.email = " "
    end

    it "should not be valid" do
      expect(@user.valid?).to eq(false)
    end
  end
end

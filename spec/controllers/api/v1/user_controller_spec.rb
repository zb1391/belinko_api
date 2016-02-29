require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "#POST create" do
    describe "when facebook authenticates successfully" do
      before(:all) do
        @count = User.all.count
      end
      before(:each) do
        post :create
      end

      it { should respond_with 201 }

      it "creates a new user" do
        expect(User.all.count).to eql(@count+1)
      end
    end
  end
end

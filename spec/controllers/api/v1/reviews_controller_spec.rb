require 'spec_helper'

RSpec.describe Api::V1::ReviewsController, type: :controller do
  describe "POST #create" do
    describe "when POSTING to a new place" do
      context "when successfully created" do
        before(:each) do
          @user = FactoryGirl.create :user, auth_token: (User.count+1).to_s+'-token'
          request.headers["Authorization"] = @user.auth_token
          post :create, { review: { place: { gid: (Place.count+1).to_s, name: 'test', latitude: 10, longitude: 10 }, comment: 'test', would_recommend: false } }
        end

        it { should respond_with 201 }

        it "renders the review as json" do
          resp = json_response
          expect(resp[:comment]).to eql('test')
        end

        it "creates the place as well" do
          expect(Place.find_by(gid: Place.count).nil?).to eql(false)
        end

        it "sets the likes/dislikes value based on would_recommend" do
          place = Place.find_by(gid: Place.count)
          expect(place.dislikes).to eql(1)
        end
      end

      context "when is not created" do
        before(:each) do
          @user = FactoryGirl.create :user, auth_token: (User.count+1).to_s+'-token'
          request.headers["Authorization"] = @user.auth_token
          post :create, { review: { place: {} } }
        end

        it { should respond_with 422 }

        it "renders the errors" do
          resp = json_response
          expect(resp).to have_key(:errors)
        end
      end
    end

    describe "when POSTING to an existing place" do
      context "when successfully created" do
        before(:each) do
          @user = FactoryGirl.create :user, auth_token: (User.count+1).to_s+'-token'
          @place = FactoryGirl.create :place, gid: (Place.count+1).to_s
          request.headers["Authorization"] = @user.auth_token
          post :create, { review: { place: { gid: @place.gid },  comment: 'test' } }
        end


        it { should respond_with 201 }
        
        it "renders the review as json" do
          resp = json_response
          expect(resp[:comment]).to eql('test')
        end
      end
    end
  end
end

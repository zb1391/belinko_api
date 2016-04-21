require "spec_helper"

require "#{Rails.root}/lib/google_places/google_places_api.rb"
require "#{Rails.root}/lib/google_places/google_places_api/getter.rb"

include GooglePlacesApi
include GooglePlacesHelpers

describe GooglePlacesApi::Getter do
  before(:all) do
    @user = FactoryGirl.create :user
    @user_id = @user.id
  end

  describe "#parse_body" do
    before(:each) do
      @response = {
        "status" => "OK",
        "result" => GooglePlacesHelpers.google_place_response
      }.to_json
      @getter = GooglePlacesApi::Getter.new(@user_id,"123")
      @getter.send :parse_body, @response
    end

    it "sets status" do
      expect(@getter.status).to eql("OK")
    end

    it "sets place" do
      expect(@getter.place.nil?).to eql(false)
    end
  end

  describe "#json_response" do
    before(:each) do
      @response = {
        "status" => "OK",
        "results" => GooglePlacesHelpers.google_place_response
      }.to_json
      @getter = GooglePlacesApi::Getter.new(@user_id,"123")
      @getter.send :parse_body, @response
      @results = @getter.json_response
    end

    it "returns a status" do
      expect(@results["status"]).to eql("OK")
    end

    it "returns no errors" do
      expect(@results["errors"]).to eql(nil)
    end

    it "returns a place" do
      expect(@results["place"].nil?).to eql(false)
    end
  end
end

describe GooglePlacesApi::GooglePlaceDetail do
  before(:each) do
    @user_id = (FactoryGirl.create :user).id
    @google_resp = GooglePlacesHelpers.google_place_response
  end

  describe "#add_likes" do
    before(:each) do
      @place = FactoryGirl.create(:place, gid: "#{Place.count+1}", would_recommend: true)
      @google_resp["place_id"] = @place.gid
    end

    it "adds belinko_likes to the google_resp" do
      google_place = GooglePlacesApi::GooglePlaceDetail.new(@user_id,{google_resp: @google_resp})
      google_place.send :add_likes
      expect(@google_resp["belinko_likes"]).to eql(1)
    end

    it "adds belinko_dislikes to the google_resp" do
      google_place = GooglePlacesApi::GooglePlaceDetail.new(@user_id,{google_resp: @google_resp})
      google_place.send :add_likes
      expect(@google_resp["belinko_dislikes"]).to eql(0)
    end
  end

  describe "#add_reviews" do
    before(:each) do
      @place = FactoryGirl.create(:place, gid: "#{Place.count+1}")
      3.times { FactoryGirl.create(:review, place: @place,user_id: @user_id) }
      @google_resp["place_id"] = @place.gid
    end

    it "adds reviews to the google_resp" do
      google_place = GooglePlacesApi::GooglePlaceDetail.new(@user_id,{google_resp: @google_resp})
      google_place.send :add_reviews
      @place.reviews.each do |review|
        expect(@google_resp["belinko_reviews"]).to include(review.as_json)
      end
    end
  end
end

require 'spec_helper'

require "#{Rails.root}/lib/google_places/google_places_api.rb"
require "#{Rails.root}/lib/google_places/google_places_api/searcher.rb"
require "#{Rails.root}/lib/google_places/google_places_api/google_place.rb"

include GooglePlacesApi
include GooglePlacesHelpers

describe GooglePlacesApi::Searcher do
  
  describe "#parse_body" do
    before(:each) do
      @response = {
        "status" => "OK",
        "results" => [GooglePlacesHelpers.google_place_response]
      }.to_json
      @places = GooglePlacesApi::Searcher.new(123,{latitude: 1, longitude: 2})
      @places.send :parse_body, @response
    end

    it "sets status" do
      expect(@places.status).to eql("OK")
    end

    it "sets places" do
      expect(@places.places.length).to eql(1)
    end
  end

  describe "#json_response" do
    before(:each) do
      user = FactoryGirl.create :user
      @response = {
        "status" => "OK",
        "results" => [GooglePlacesHelpers.google_place_response]
      }.to_json
      @places = GooglePlacesApi::Searcher.new(user.id,{latitude: 1, longitude: 2})
      @places.send :parse_body, @response
      @results = @places.json_response
    end

    it "returns a status" do
      expect(@results["status"]).to eql("OK")
    end

    it "returns no errors" do
      expect(@results["errors"]).to eql(nil)
    end

    it "returns places" do
      expect(@results["places"][0].nil?).to eql(false)
    end
  end

  describe "#add_belinko_places" do
    before(:all) do
      @user = FactoryGirl.create :user
      @nearby = FactoryGirl.create :place, latitude: 41.7389968, longitude: -77.992368 
    end

    describe "when the place is not already in the @places hash" do
      before(:each) do
        @searcher = GooglePlacesApi::Searcher.new(@user.id,{latitude: 41.7389968, longitude: -77.992368, radius: 1500})
      end

      describe "and it was reviewed by the user or the users friends" do
        before(:each) do
          FactoryGirl.create :review, user: @user, place: @nearby
          @searcher.send :add_belinko_places
        end

        it "adds it to @places" do
          expect(@searcher.places.keys.empty?).to eql(false)
        end
      end

      describe "and it was not reviewed by the user of the users friends" do
        it "does not add it to @places" do
          @searcher.send :add_belinko_places
          expect(@searcher.places.keys.empty?).to eql(true)
        end
      end
    end
  end
end

describe GooglePlacesApi::GooglePlace do
  before(:each) do
    @google_resp = GooglePlacesHelpers.google_place_response
  end

  describe "#initialize" do
    it "sets google_resp" do
      google_place = GooglePlacesApi::GooglePlace.new(123,{google_resp: @google_resp})
      expect(google_place.google_resp.nil?).to eql(false)
    end

    it "sets place" do
      google_place = GooglePlacesApi::GooglePlace.new(123,{google_resp: @google_resp})
      expect(google_place.place.id.nil?).to eql(false)
    end

  end

  describe "#json_response" do
    it "returns the google_resp as json" do
      google_place = GooglePlacesApi::GooglePlace.new(123,{google_resp: @google_resp})
      expect(google_place.json_response).to eql(google_place.google_resp.to_json)
    end
  end

  describe "#add_reviews" do
    before(:each) do
      @place = FactoryGirl.create(:place, gid: "#{Place.count+1}")
      3.times { FactoryGirl.create(:review, place: @place) }
      @google_resp["place_id"] = @place.gid
    end

    it "adds reviews to the google_resp" do
      google_place = GooglePlacesApi::GooglePlace.new(123,{google_resp: @google_resp})
      google_place.send :add_reviews
      expect(@google_resp["reviews"]).to eql(3)
    end
  end
end

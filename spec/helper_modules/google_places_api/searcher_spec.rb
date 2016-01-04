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
      @places = GooglePlacesApi::Searcher.new(latitude: 1, longitude: 2)
      @places.send :parse_body, @response
    end

    it "sets status" do
      expect(@places.status).to eql("OK")
    end

    it "sets places" do
      expect(@places.places.length).to eql(1)
    end
  end
end

describe GooglePlacesApi::GooglePlace do
  before(:each) do
    @google_resp = GooglePlacesHelpers.google_place_response
  end

  describe "#initialize" do
    it "sets google_resp" do
      google_place = GooglePlacesApi::GooglePlace.new(google_resp: @google_resp)
      expect(google_place.google_resp.nil?).to eql(false)
    end

    it "sets place" do
      google_place = GooglePlacesApi::GooglePlace.new(google_resp: @google_resp)
      expect(google_place.place.id.nil?).to eql(false)
    end

  end

  describe "#add_reviews" do
    before(:each) do
      @place = FactoryGirl.create(:place, gid: "#{Place.count+1}")
      3.times { FactoryGirl.create(:review, place: @place) }
      @google_resp["place_id"] = @place.gid
    end

    it "adds reviews to the google_resp" do
      google_place = GooglePlacesApi::GooglePlace.new(google_resp: @google_resp)
      google_place.send :add_reviews
      @place.reviews.each do |review|
        expect(@google_resp["reviews"]).to include(review.as_json)
      end
    end
  end
end

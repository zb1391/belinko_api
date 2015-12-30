require 'spec_helper'

require "#{Rails.root}/lib/google_places/google_places.rb"
require "#{Rails.root}/lib/google_places/google_place.rb"

include GooglePlaces
describe GooglePlaces::GooglePlaces do
  describe "#initialize" do
    it "raises an error when missing the latitude argument" do
      expect{GooglePlaces::GooglePlaces.new(longitude: 123) }.to raise_error(ArgumentError)
    end

    it "raises an error whem missing the longitude argument" do
      expect{GooglePlaces::GooglePlaces.new(latitude: 123) }.to raise_error(ArgumentError)
    end
  end

  describe "when no additional options are passed" do
    it "uses the defaults" do
      places = GooglePlaces::GooglePlaces.new(latitude: 123, longitude: 456)
      expected = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=123,456&radius=#{GooglePlaces::RADIUS}&types=#{GooglePlaces::TYPES}&key=#{GooglePlaces::API_KEY}"
      expect(places.url).to eql(expected)
    end
  end
end

describe GooglePlaces::GooglePlace do
  before(:each) do
    place = Place.first.nil? ? FactoryGirl.create(:place) : Place.first
    @google_resp = {
      "place_id" => place.gid,
      "name"     => place.name,
      "geometry" => {
        "location" => {
          "lat" => 123,
          "lng" => 102,
        },
      },
    }
  end

  describe "#initialize" do
    it "sets google_resp" do
      google_place = GooglePlaces::GooglePlace.new(google_resp: @google_resp)
      expect(google_place.google_resp.nil?).to eql(false)
    end

    it "sets place" do
      google_place = GooglePlaces::GooglePlace.new(google_resp: @google_resp)
      expect(google_place.place.id).to eql(Place.first.id)
    end

    describe "when the place does not yet exist" do
      before(:each) do
        place = Place.last
        @google_resp["place_id"] = "#{place.gid.to_i+1}"
      end

      it "creates a new place" do
        count = Place.count
        GooglePlaces::GooglePlace.new(google_resp: @google_resp)
        expect(Place.count).to eql(count+1)
      end
    end
  end

  describe "#add_reviews" do
    before(:each) do
      @place = FactoryGirl.create(:place, gid: "#{Place.count+1}")
      3.times { FactoryGirl.create(:review, place: @place) }
      @google_resp["place_id"] = @place.gid
    end

    it "adds reviews to the google_resp" do
      google_place = GooglePlaces::GooglePlace.new(google_resp: @google_resp)
      google_place.send :add_reviews
      @place.reviews.each do |review|
        expect(@google_resp["reviews"]).to include(review.as_json)
      end
    end
  end
end

require 'spec_helper'

require "#{Rails.root}/lib/google_places/nearby_search.rb"

include GooglePlacesApi
include GooglePlacesHelpers

describe GooglePlacesApi::NearbySearch do
  describe "#initialize" do
    it "raises an error when missing the latitude argument" do
      expect{GooglePlacesApi::NearbySearch.new(longitude: 123) }.to raise_error(ArgumentError)
    end

    it "raises an error whem missing the longitude argument" do
      expect{GooglePlacesApi::NearbySearch.new(latitude: 123) }.to raise_error(ArgumentError)
    end

    describe "when no additional options are passed" do
      it "uses the defaults" do
        places = GooglePlacesApi::NearbySearch.new(latitude: 123, longitude: 456)
        expected = "https://maps.googleapis.com/maps/api/place/radarsearch/json?location=123,456&radius=#{Searcher::RADIUS}&types=#{Searcher::TYPES}&key=#{Searcher::API_KEY}"
        expect(places.url).to eql(expected)
      end
    end

    describe "when additional arguments are passed" do
      before(:each) do
        options = {
          latitude: 123,
          longitude: 456,
          name: "test",
          opennow: true,
          rankby: "distance",
          pagetoken: "abc-123",
          zagatselected: true,
        }
        @places = GooglePlacesApi::NearbySearch.new(options)
      end

      it "includes name in the url" do
        expect(@places.url).to include("&name=test")
      end

      it "includes opennow in the url" do
        expect(@places.url).to include("&opennow")
      end

      it "includes rankby in the url" do
        expect(@places.url).to include("&rankby=distance")
      end

      it "includes pagetoken in the url" do
        expect(@places.url).to include("&pagetoken=abc-123")
      end

      it "includes zagatselected in the url" do
        expect(@places.url).to include("&zagatselected")
      end
    end
  end
end

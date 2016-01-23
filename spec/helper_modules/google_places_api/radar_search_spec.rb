require 'spec_helper'

require "#{Rails.root}/lib/google_places/google_places_api/radar_search.rb"

include GooglePlacesApi
include GooglePlacesHelpers

describe GooglePlacesApi::RadarSearch do
  describe "#initialize" do
    it "sets error.latitude when the option is missing" do
      g = GooglePlacesApi::RadarSearch.new(longitude: 123)
      expect(g.error[:latitude]).to eql('latitude is a required option')
    end

    it "raises an error whem missing the longitude argument" do
      g = GooglePlacesApi::RadarSearch.new(latitude: 123)
      expect(g.error[:longitude]).to eql('longitude is a required option')
    end

    describe "when no additional options are passed" do
      it "uses the defaults" do
        places = GooglePlacesApi::RadarSearch.new(latitude: 123, longitude: 456)
        expected = "https://maps.googleapis.com/maps/api/place/radarsearch/json?location=123,456&radius=#{Searcher::RADIUS}&types=#{Searcher::TYPES}&key=#{Searcher::API_KEY}"
        expect(places.url).to eql(expected)
      end
    end

    describe "when additional arguments are passed" do
      before(:each) do
        @places = GooglePlacesApi::RadarSearch.new(latitude: 123, longitude: 456, name: 'test', opennow: true, zagatselected: true)
      end

      it "includes name in the url" do
        expect(@places.url).to include("&name=test")
      end

      it "includes opennow in the url" do
        expect(@places.url).to include("&opennow")
      end

      it "includes zagatselected in the url" do
        expect(@places.url).to include("&zagatselected")
      end
    end
  end
end

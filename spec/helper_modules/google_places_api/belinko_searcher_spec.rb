require 'spec_helper'

require "#{Rails.root}/lib/google_places/google_places_api.rb"
require "#{Rails.root}/lib/google_places/google_places_api/belinko_searcher.rb"

include GooglePlacesApi

describe GooglePlacesApi::BelinkoSearcher do
  before(:all) do
    FactoryGirl.create :place, latitude: 40.7389968, longitude: -73.992368
    FactoryGirl.create :place, latitude: 33.86879, longitude: 151.194217 
  end
  describe "#nearby_places" do
    it "returns an empty array when no radius" do
      searcher = GooglePlacesApi::BelinkoSearcher.new(latitude: 123, longitude: 456)
      places = searcher.nearby_places
      expect(places).to eql([])
    end

    it "returns an empty array when no latitude" do
      searcher = GooglePlacesApi::BelinkoSearcher.new(radius: 1500, longitude: 456)
      places = searcher.nearby_places
      expect(places).to eql([])
    end

    it "returns an empty array when no longitude" do
      searcher = GooglePlacesApi::BelinkoSearcher.new(radius: 1500, longitude: 456)
      places = searcher.nearby_places
      expect(places).to eql([])
    end

    describe "when lat/lng/radius are all present" do
      before(:each) do
        @searcher = GooglePlacesApi::BelinkoSearcher.new(latitude:40.7628915, longitude: -73.9753618, radius: 1500)
      end

      it "returns belinko_places within the surrounding radius" do
        places = @searcher.nearby_places
        expect(places.length).to eql(1)
      end
    end
  end
end

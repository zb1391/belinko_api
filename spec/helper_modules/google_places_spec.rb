require 'spec_helper'

require "#{Rails.root}/lib/google_places.rb"

include GooglePlaces
describe GooglePlaces do
  describe "#build_url" do
    it "raises an error when missing the latitude argument" do
      expect{ build_url(longitude: 123) }.to raise_error(ArgumentError)
    end

    it "raises an error whem missing the longitude argument" do
      expect{ build_url(latitude: 123) }.to raise_error(ArgumentError)
    end
  end

  describe "when no additional options are passed" do
    it "uses the defaults" do
      url = build_url(latitude: 123, longitude: 456)
      expected = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=123,456&radius=#{GooglePlaces::RADIUS}&types=#{GooglePlaces::TYPES}&key=#{GooglePlaces::API_KEY}"
      expect(url).to eql(expected)
    end
  end
end

require "spec_helper"

require "#{Rails.root}/lib/google_places/google_places_api.rb"
require "#{Rails.root}/lib/google_places/google_places_api/getter.rb"

include GooglePlacesApi
include GooglePlacesHelpers

describe GooglePlacesApi::PlacesDetail do
  describe "#parse_body" do
    before(:each) do
      @response = {
        "status" => "OK",
        "result" => GooglePlacesHelpers.google_place_response
      }.to_json
      @getter = GooglePlacesApi::PlacesDetail.new("123")
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
      @getter = GooglePlacesApi::PlacesDetail.new("123")
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

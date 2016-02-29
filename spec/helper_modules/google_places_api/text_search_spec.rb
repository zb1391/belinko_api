require 'spec_helper'

require "#{Rails.root}/lib/google_places/google_places_api/text_search.rb"

include GooglePlacesApi
include GooglePlacesHelpers

describe GooglePlacesApi::TextSearch do
  describe "#initialize" do
    it "sets error.latitude when the option is missing" do
      g = GooglePlacesApi::TextSearch.new
      expect(g.error[:query]).to eql('query is a required option')
    end

    describe "when no additional options are passed" do
      it "uses the defaults" do
        places = GooglePlacesApi::TextSearch.new(query: "test search")
        expected = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=test+search&type=#{Searcher::TYPE}&key=#{Searcher::API_KEY}"
        expect(places.url).to eql(expected)
      end
    end

    describe "when additional arguments are passed" do
      before(:each) do
        @options = {
          query: "test",
          minprice: 0,
          maxprice: 4,
          opennow: true,
          pagetoken: "abc-123",
          zagatselected: true,
        }
        @places = GooglePlacesApi::TextSearch.new(@options)
      end
      
      describe "and both latitude and longitude are present" do
        before(:each) do 
          options = @options.clone
          options[:latitude] = 123
          options[:longitude] = 456
          @places = GooglePlacesApi::TextSearch.new(options)
        end

        it "includes the radius option" do
          expect(@places.url).to include("&radius=#{Searcher::RADIUS}") 
        end

        it "includes the location option" do
          expect(@places.url).to include("&location=123,456")
        end
      end

      it "includes the minprice in the url" do
        expect(@places.url).to include("&minprice=0")
      end

      it "includes the maxprice in the url" do
        expect(@places.url).to include("&maxprice")
      end

      it "includes opennow in the url" do
        expect(@places.url).to include("&opennow")
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

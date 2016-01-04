require 'spec_helper'

require "#{Rails.root}/lib/google_places/google_places_api.rb"
require "#{Rails.root}/lib/google_places/google_places_api/searcher.rb"
require "#{Rails.root}/lib/google_places/google_places_api/google_place.rb"
require "#{Rails.root}/lib/google_places/google_places_api/text_search.rb"

include GooglePlacesApi
include GooglePlacesHelpers

describe GooglePlacesApi do
  describe "#get_isntance_type" do
    it "returns an ArgumentError when an unknown type is passed" do
      expect{get_instance_type("badtype")}.to raise_error(ArgumentError)
    end

    it "returns the class of the searcher" do
      expect(get_instance_type("text")).to eql(GooglePlacesApi::TextSearch)
    end
  end
end

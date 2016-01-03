
require 'net/http'
require_relative './google_places_helpers'
module GooglePlacesApi
  # radius is in meters ~ 2 miles
  RADIUS  = 3000
  TYPES   = "food"
  API_KEY = ENV["GOOGLE_PLACES_KEY"]

  # make a request to the google places api
  def self.search!(options = {})
    places = GooglePlacesApi::GooglePlaces.new(options)
    places.search
    return places
  end

  class Searcher
    include GooglePlacesApi::GooglePlacesHelpers

    attr_reader :url, :status, :error, :places


    def initialize(options = {})
      @url    = build_url(options)
      @places = []
    end

    private

    # build the url for the google places api
    def build_url(options = {})
      raise ArgumentError, 'latitude is a required option' unless options[:latitude]
      raise ArgumentError, 'longitude is a required option' unless options[:longitude]
      radius = options[:radius] || RADIUS
      types  = options[:type]   || TYPES
      url = ("https://maps.googleapis.com/maps/api/place/nearbysearch/json?" +
             "location=#{options[:latitude]},#{options[:longitude]}" +
             "&radius=#{radius}" +
             "&types=#{types}" +
             "&key=#{API_KEY}")
      url += "&name=#{options[:name]}" if options[:name]
      return url
    end
  end
end

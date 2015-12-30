
require 'net/http'

module GooglePlaces
  RADIUS  = 2
  TYPES   = "food"
  API_KEY = ENV["GOOGLE_PLACES_KEY"]

  # make a request to the google places api
  def search!(options = {})
    places = GooglePlaces::GooglePlaces.new(options)
    places.search
    return places
  end

  class GooglePlaces
    attr_accessor :url, :status, :error, :places

    def initialize(options = {})
      @url    = build_url(options)
      @places = []
    end


    # make a request to the google places api
    def search(options = {})
      url = URI.parse(@url)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      parse_body(res.body)
    end

    private

    # build the url for the google places api
    def build_url(options = {})
      raise ArgumentError, 'latitude is a required option' unless options[:latitude]
      raise ArgumentError, 'longitude is a required option' unless options[:longitude]
      radius = options[:radius] || GooglePlaces::RADIUS
      types  = options[:type]   || GooglePlaces::TYPES
      url = ("https://maps.googleapis.com/maps/api/place/nearbysearch/json?" +
             "location=#{options[:latitude]},#{options[:longitude]}" +
             "&radius=#{radius}" +
             "&types=#{types}" +
             "&key=#{GooglePlaces::API_KEY}")
      url += "&name=#{options[:name]}" if options[:name]
      return url
    end

    # sets the places array and the error attribute
    def parse_body(response)
      if response["status"] == "OK"

      else
        # return an error response somehow
      end
    end
  end

end

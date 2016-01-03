
require 'net/http'

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
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")
      res = http.request(req)
      parse_body(res.body)
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

    # sets the places array and the error attribute
    # there is a next_page_token attribute which can be used to fetch more results
    # of the same query - i am not sure if i want to build something to recurisvely get more
    # until there arent any
    # right now it returns 20 at a time - i could change it use radar search instead
    # this allows for more results but less detail (like the photos and stuff)
    # i think i should build in to this the type of search you want to do 
    # and allow for things like text-search vs radar search...
    def parse_body(response)
      response = JSON.parse(response)
      @status = response["status"]
      @error  = response["error_message"]
      
      set_places(response["results"])
    end

    def set_places(results)
      results.each do |google_place|
        @places << GooglePlacesApi::GooglePlace.new(google_resp: google_place)
      end
    end
  end
end

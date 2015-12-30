require 'net/http'

module GooglePlaces
  RADIUS  = 2
  TYPES   = "food"
  API_KEY = ENV["GOOGLE_PLACES_KEY"]

  # build the url for the google places api
  def build_url(options = {})
    raise ArgumentError, 'latitude is a required option' unless options[:latitude]
    raise ArgumentError, 'longitude is a required option' unless options[:longitude]
    radius = options[:radius] || RADIUS
    types = options[:type] || TYPES
    url = ("https://maps.googleapis.com/maps/api/place/nearbysearch/json?" +
              "location=#{options[:latitude]},#{options[:longitude]}" +
              "&radius=#{radius}" +
              "&types=#{types}" +
              "&key=#{API_KEY}")
    url += "&name=#{options[:name]}" if options[:name]
    return url
  end

  # make a request to the google places api
  def search_places(options = {})
    url = URI.parse(build_url(options))
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    parse_body(res)
  end

  # parse the response of the google api request
  # what do i want to do? raise an exception if the status code is not 200?
  # do i want to return nil? - i probably want to return an object that includes a status code and the json response
  # maybe it would be best to create a class and have it return an array of objects - that way each object can do its own thing 
  # with its data separately
  def parse_body(response)
    
  end

end

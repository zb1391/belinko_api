module GooglePlaces
  RADIUS  = 2
  TYPES   = "food"
  API_KEY = ENV["GOOGLE_PLACES_KEY"]

  def self.build_url(options = {})
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
end

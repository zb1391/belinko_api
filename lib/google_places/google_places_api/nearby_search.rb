require_relative './searcher.rb'

module GooglePlacesApi
  class NearbySearch < GooglePlacesApi::Searcher
    def initialize(options={})
      @url = build_url(options)
      super(options)
    end

    private
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

      url += "&keyword=#{options[:keyword]}"     if options[:keyword]
      url += "&name=#{options[:name]}"           if options[:name]
      url += "&opennow=true"                     if options[:opennow]
      url += "&rankby=#{options[:rankby]}"       if options[:rankby]
      url += "&pagetoken=#{options[:pagetoken]}" if options[:pagetoken]
      url += "&zagatselected"                    if options[:zagatselected]
      url += "&minprice=#{options[:minprice]}"   if options[:minprice]
      url += "&maxprice=#{options[:maxprice]}"   if options[:maxprice]
      return url
    end
  end
end

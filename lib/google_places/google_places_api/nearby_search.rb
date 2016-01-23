require_relative './searcher.rb'

module GooglePlacesApi
  class NearbySearch < GooglePlacesApi::Searcher
    def initialize(options={})
      super(options)
      check_required_options(options)
      @url = build_url(options)
    end

    private
    def check_required_options(options = {})
      @error[:latitude]  = 'latitude is a required option' unless options[:latitude]
      @error[:longitude] = 'longitude is a required option' unless options[:longitude]
    end

    def build_url(options = {})
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

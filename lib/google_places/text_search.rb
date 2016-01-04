require_relative './google_places'

module GooglePlacesApi
  class TextSearch < GooglePlacesApi::Searcher
    def initialize(options={})
      @url = build_url(options)
      super(options)
    end

    private
    def build_url(options = {})
      raise ArgumentError, 'query is a required option' unless options[:query]
      radius = options[:radius] || RADIUS
      types  = options[:type]   || TYPES
      url = ("https://maps.googleapis.com/maps/api/place/textsearch/json?" +
             "query=#{options[:query].gsub(/\s/,"+")}" +
             "&types=#{types}" +
             "&key=#{API_KEY}")
      
      url += "&minprice=#{options[:minprice]}"   if options[:minprice]
      url += "&maxprice=#{options[:maxprice]}"   if options[:maxprice]
      url += "&pagetoken=#{options[:pagetoken]}" if options[:pagetoken]
      url += "&opennow=true"                     if options[:opennow]
      url += "&zagatselected"                    if options[:zagatselected]
      if options[:latitude] && options[:longitude]
        url += "&radius=#{options[:radius] || RADIUS}"
        url += "&location=#{options[:latitude]},#{options[:longitude]}"
      end
      return url
    end
  end
end

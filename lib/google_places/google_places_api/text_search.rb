require_relative './searcher.rb'

module GooglePlacesApi
  class TextSearch < GooglePlacesApi::Searcher
    def initialize(user_id,options={})
      super(user_id,options)
      check_required_options(options)
      @url = build_url(options)
    end

    private
    def check_required_options(options = {})
      @error[:query]  = 'query is a required option' unless options[:query]
    end

    def build_url(options = {})
      radius = options[:radius] || RADIUS
      type  = options[:type]   || TYPE
      query  = options[:query]  || ''

      url = ("https://maps.googleapis.com/maps/api/place/textsearch/json?" +
             "query=#{query.gsub(/\s/,"+")}" +
             "&type=#{type}" +
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

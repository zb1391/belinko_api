require_relative './searcher.rb'

module GooglePlacesApi
  class RadarSearch < GooglePlacesApi::Searcher
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
      type  = options[:type]   || TYPE
      url = ("https://maps.googleapis.com/maps/api/place/radarsearch/json?" +
             "location=#{options[:latitude]},#{options[:longitude]}" +
             "&radius=#{radius}" +
             "&type=#{type}" +
             "&key=#{API_KEY}")
      url += "&keyword=#{options[:keyword]}" if options[:keyword]
      url += "&name=#{options[:name]}" if options[:name]
      url += "&opennow" if options[:opennow]
      url += "&zagatselected" if options[:zagatselected]
      return url
    end
  end
end

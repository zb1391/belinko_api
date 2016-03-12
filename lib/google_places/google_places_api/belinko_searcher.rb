module GooglePlacesApi
  class BelinkoSearcher
    attr_reader :latitude,:longitude,:radius
    
    def initialize(options = {})
      @radius = options[:radius]
      @latitude = options[:latitude]
      @longitude = options[:longitude]
    end

    # get all belinko places nearby
    def nearby_places
      places = []
      if @radius && @latitude && @longitude
        # do something
      end
      return places
    end
  end
end

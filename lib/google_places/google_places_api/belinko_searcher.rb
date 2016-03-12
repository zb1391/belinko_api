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
      return [] unless @radius && @latitude && @longitude

      radius_km = @radius.to_f/1000
      Place.within(radius_km, origin: [@latitude,@longitude])
    end
  end
end

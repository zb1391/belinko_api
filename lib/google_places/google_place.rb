module GooglePlaces
  class GooglePlace
    attr_accessor :google_resp, :place

    def initialize(options={})
      @google_resp = options[:google_resp]
      
      @place = Place.find_or_create_by(gid: @google_resp[:place_id]) do |place|
        place.name      = @google_resp[:name]
        place.latitude  = @google_resp[:geometry][:location][:lat]
        place.longitude = @google_resp[:geometry][:location][:lng]
      end
    end

  end
end

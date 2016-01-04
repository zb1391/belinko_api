module GooglePlacesApi
  class GooglePlace
    attr_reader :google_resp, :place

    def initialize(options={})
      @google_resp = options[:google_resp]
       
      @place = Place.find_or_initialize_by(gid: @google_resp["place_id"]) do |place|
        place.name      = @google_resp["name"]
        place.latitude  = @google_resp["geometry"]["location"]["lat"]
        place.longitude = @google_resp["geometry"]["location"]["lng"]
      end
      
      add_reviews
    end
    
    private
    def add_reviews
      @google_resp["reviews"] = []
      @place.reviews.each do |review|
        @google_resp["reviews"] << review.as_json
      end
    end
  end
end

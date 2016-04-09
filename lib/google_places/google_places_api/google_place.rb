module GooglePlacesApi
  class GooglePlace
    attr_reader :google_resp, :place

    def initialize(options={})
      @google_resp = options[:google_resp] || {}
      
      unless @google_resp.empty?
        @place = Place.find_or_initialize_by(gid: @google_resp["place_id"]) do |place|
          place.name      = @google_resp["name"]
          place.latitude  = @google_resp["geometry"]["location"]["lat"]
          place.longitude = @google_resp["geometry"]["location"]["lng"]
          place.likes     = 0
          place.dislikes  = 0
        end
      
        add_belinko_data
      end
    end

    def json_response
      @google_resp.to_json
    end    


    private

    def add_belinko_data
      add_reviews
    end

    def add_reviews
      @google_resp["reviews"] = @place.reviews.count || 0
    end
  end
end

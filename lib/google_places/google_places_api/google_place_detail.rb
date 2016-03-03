require_relative './google_place.rb'

module GooglePlacesApi
  class GooglePlaceDetail < GooglePlacesApi::GooglePlace

    private
    def add_reviews
      @google_resp["reviews"] = []
      @place.reviews.each do |review|
        @google_resp["reviews"] << review.as_json
      end
    end
  end
end

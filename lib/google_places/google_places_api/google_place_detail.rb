require_relative './google_place.rb'

module GooglePlacesApi
  class GooglePlaceDetail < GooglePlacesApi::GooglePlace

    private

    def add_belinko_data
      add_reviews
      add_likes
    end

    def add_likes
      @google_resp["belinko_likes"] = @place.likes
      @google_resp["belinko_dislikes"] = @place.dislikes
    end

    def add_reviews
      @google_resp["belinko_reviews"] = []
      json_options = { include: { user: { only: [:name, :id, :thumbnail] } } }
      ids = User.find(@user_id).friends.pluck("id")
      ids << @user_id
      @place.reviews.reviewed_by(ids).each do |review|
        @google_resp["belinko_reviews"] << review.as_json(json_options)
      end
    end
  end
end

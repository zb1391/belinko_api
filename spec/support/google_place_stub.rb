
module GooglePlacesHelpers
  def google_place_response
    place = Place.first.nil? ? FactoryGirl.create(:place) : Place.first
    @google_resp ||= {
      "place_id" => place.gid,
      "name"     => place.name,
      "geometry" => {
        "location" => {
          "lat" => 123,
          "lng" => 102,
        },
      },
    }
  end
end

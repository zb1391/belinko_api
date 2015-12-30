
module GooglePlacesHelpers
  def google_place_response
    if Place.first.nil?
      place = FactoryGirl.create(:place)
    else
      place = Place.first
    end
    @google_resp = {
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

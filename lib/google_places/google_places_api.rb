require_relative "./google_places_api/radar_search.rb"
require_relative "./google_places_api/text_search.rb"
require_relative "./google_places_api/nearby_search.rb"
require_relative "./google_places_api/getter.rb"

module GooglePlacesApi
  # radius is in meters ~ 1 mile
  RADIUS    = 1500
  TYPE     = "restaurant"
  API_KEY   = ENV["GOOGLE_PLACES_KEY"]
  INSTANCES = {
    "text"   => GooglePlacesApi::TextSearch,
    "radar"  => GooglePlacesApi::RadarSearch,
    "nearby" => GooglePlacesApi::NearbySearch,
  }


  # make a request to the google places api
  def self.search!(type,options = {})
    places = self.get_instance_type(type).new(options)
    places.search
    return places
  end

  # make a request to the google places detail
  def self.get!(id)
    place = GooglePlacesApi::PlacesDetail.new(id)
    place.search
    return place
  end

  # return a type of searcher
  def self.get_instance_type(type)
    raise ArgumentError, 'unknown type' unless INSTANCES[type]
    return INSTANCES[type]
  end
end

require_relative "./google_places_api/radar_search.rb"
require_relative "./google_places_api/text_search.rb"
require_relative "./google_places_api/nearby_search.rb"
module GooglePlacesApi
  # radius is in meters ~ 2 miles
  RADIUS    = 3000
  TYPES     = "food"
  API_KEY   = ENV["GOOGLE_PLACES_KEY"]
  INSTANCES = {
    "text"   => GooglePlacesApi::TextSearch,
    "radar"  => GooglePlacesApi::RadarSearch,
    "nearby" => GooglePlacesApi::NearbySearch,
  }


  # make a request to the google places api
  def self.search!(type,options = {})
    places = get_instance_type(type).new(options)
    places.search
    return places
  end

  # return a type of searcher
  def get_instance_type(type)
    raise ArgumentError, 'unknown type' unless INSTANCES[type]
    return INSTANCES[type]
  end
end

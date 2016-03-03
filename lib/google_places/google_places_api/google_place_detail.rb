require_relative './google_place.rb'

module GooglePlacesApi
  class GooglePlaceDetail < GooglePlacesApi::GooglePlace
    def initialize(options={})
      @google_resp = options[:google_resp] || {}
    end
  end
end

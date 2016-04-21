require_relative './google_place_detail.rb'
require_relative './searcher.rb'

require 'net/http'
module GooglePlacesApi
  class Getter < GooglePlacesApi::Searcher
    attr_reader :place, :place_id

    def initialize(user_id,place_id)
      super(user_id)
      @place_id = place_id
      check_required_options()
      @url = build_url()
    end

    def json_response
      place = @place || GooglePlacesApi::GooglePlaceDetail.new()
      {
        status: @status,
        errors: @error,
        place:  place.google_resp.as_json
      }.as_json
    end

    private
    def check_required_options
      @error[:id] = "id is a required option" if @place_id.nil?
    end

    def build_url
      url = ("https://maps.googleapis.com/maps/api/place/details/json?" +
             "placeid=#{@place_id}"+
             "&key=#{API_KEY}")
      return url
    end

    # parse the response from the google api
    def parse_body(response)
      response = JSON.parse(response)
      @status = response["status"]
      @error  = response["error_message"]
      @place  = GooglePlacesApi::GooglePlaceDetail.new(google_resp: response["result"])
    end
  end
end

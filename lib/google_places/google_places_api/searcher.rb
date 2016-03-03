require_relative './google_place.rb'
require 'net/http'
module GooglePlacesApi
  class Searcher
    attr_reader :url, :status, :error, :places

    def initialize(options = {})
      @places = []
      @error = {}
    end

    # make a request to the google places api
    # does not make request if errors present
    def search(options = {})
      return if @error.keys.any?

      url = URI.parse(@url)
      req = Net::HTTP::Get.new(url.to_s)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")
      res = http.request(req)
      parse_body(res.body)
    end

    def json_response
      # google_resp contains all of the json for each place
      places_response = @places.map{ |p| p.google_resp }
      {
        status: @status,
        errors: @error,
        places: places_response.as_json,
      }.as_json
    end

    private
    # parse the response from the google api
    def parse_body(response)
      response = JSON.parse(response)
      @status = response["status"]
      @error  = response["error_message"]

      set_places(response["results"])
    end

    def set_places(results)
      results.each do |google_place|
        @places << GooglePlacesApi::GooglePlace.new(google_resp: google_place)
      end
    end
  end
end

require_relative './google_place.rb'
require_relative './belinko_searcher.rb'
require 'net/http'

module GooglePlacesApi
  class Searcher
    attr_reader :url, :status, :error, :places, :user_id

    def initialize(user_id,options = {})
      @user_id = user_id
      @places = {}
      @error = {}
      @belinko_searcher = GooglePlacesApi::BelinkoSearcher.new(user_id,options)
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
      places_response = []
      @places.each {|gid,place| places_response << place.google_resp}
      {
        status: @status,
        errors: @error,
        places: places_response.as_json,
      }.as_json
    end

    private

    # adds nearby belinko places to the google response
    def add_belinko_places
      nearby = @belinko_searcher.nearby_places
      nearby.each do |place|
        unless @places[place.gid]
          @places["#{place.gid}"] = place.as_google_json
        end
      end
    end

    # parse the response from the google api
    # add nearby belinko places to the response
    def parse_body(response)
      response = JSON.parse(response)
      @status = response["status"]
      @error  = response["error_message"]

      set_places(response["results"])
      add_belinko_places
    end

    def set_places(results)
      results.each do |google_place|
        @places[google_place["place_id"]] = GooglePlacesApi::GooglePlace.new(google_resp: google_place)
      end
    end
  end
end

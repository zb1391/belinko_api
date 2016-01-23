class Api::V1::GooglePlacesController < ApplicationController
  respond_to :json
  helper_method :missing_params

  def radar_search
    res = GooglePlacesApi.search!("radar",params)
    render json: res.json_response, status: 200
  end

  def nearby_search
    res = GooglePlacesApi.search!("nearby",params)
    render json: res.json_response, status: 200
  end

end

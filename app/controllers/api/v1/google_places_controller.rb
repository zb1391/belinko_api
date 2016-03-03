# FUCK the fucking autoload bull shit
# i dont know how to get my shit to work without explicitly requiring what i want
# did i mention to fuck autoloading?
require_relative "../../../../lib/google_places/google_places_api.rb"
require_relative "../../../../lib/omniauth/facebook.rb"

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

  def text_search
    res = GooglePlacesApi.search!("text",params)
    render json: res.json_response, status: 200
  end

  def detail
    res = GooglePlacesApi.get!(params[:id])
    render json: res.json_response, status: 200
  end
end

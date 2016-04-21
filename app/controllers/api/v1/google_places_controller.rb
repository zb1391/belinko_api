# FUCK the fucking autoload bull shit
# i dont know how to get my shit to work without explicitly requiring what i want
# did i mention to fuck autoloading?
require_relative "../../../../lib/google_places/google_places_api.rb"
require_relative "../../../../lib/omniauth/facebook.rb"

class Api::V1::GooglePlacesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json
  helper_method :missing_params
  
  def radar_search
    id = current_user.id
    res = GooglePlacesApi.search!("radar",id,params)
    render json: res.json_response, status: 200
  end

  def nearby_search
    id = current_user.id
    res = GooglePlacesApi.search!("nearby",id,params)
    render json: res.json_response, status: 200
  end

  def text_search
    id = current_user.id
    res = GooglePlacesApi.search!("text",id,params)
    render json: res.json_response, status: 200
  end

  def detail
    id = current_user.id
    res = GooglePlacesApi.get!(id,params[:id])
    render json: res.json_response, status: 200
  end
end

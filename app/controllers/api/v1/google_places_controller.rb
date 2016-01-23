class Api::V1::GooglePlacesController < ApplicationController
  respond_to :json
  helper_method :missing_params

  def radar_search
    errors = missing_params(params)
    if(errors)
      render json: { errors: errors }, status: 400
    else
      places = GooglePlacesApi.search!("radar",params)
      render json: {places: places.places}, status: 200
    end
  end


  private
  def missing_params(params = {})
    return nil if params[:latitude] && params[:longitude]
    
    errors = {}
    errors[:latitude]  = "latitude is required"  unless params[:latitude]
    errors[:longitude] = "longitude is required" unless params[:longitude]
    return errors
  end
end

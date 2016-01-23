class Api::V1::GooglePlacesController < ApplicationController
  respond_to :json
  helper_method :missing_params

  def radar_search
    errors = missing_params(params)
    if(errors)
      render json: { errors: errors }, status: 400
    else
      render json: {}, status: 200
    end
  end


  private
  def missing_params(params = {})
    return nil if params[:lat] && params[:long]
    
    errors = {}
    errors[:lat]  = "lat is required"  unless params[:lat]
    errors[:long] = "long is required" unless params[:long]
    return errors
  end
end

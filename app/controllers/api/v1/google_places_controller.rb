# FUCK the fucking autoload bull shit
# i dont know how to get my shit to work without explicitly requiring what i want
# did i mention to fuck autoloading?
require_relative "../../../../lib/google_places/google_places_api.rb"
require_relative "../../../../lib/omniauth/facebook.rb"

class Api::V1::GooglePlacesController < ApplicationController
  respond_to :json
  helper_method :missing_params
  
  def test
    render json: {test: true}, status: 200
  end

  def login_test
    begin
      user_creds = Omniauth::Facebook.authenticate(params[:code])
      # finds the user or creates one
      @user = User.from_omniauth(user_creds)
      if @user.persisted?
        @user.update_auth_token(user_creds["token"])
        sign_in @user, event: :authentication
        # return the omni-auth data in the response
        # including the user's uid and the auth-token
        render json: user_creds, status: 201
      else
        render json: {errors: {facebook: "Failed to log in"}}, status: 422
      end
    rescue
      render json: {errors: {facebook: "Failed to log in"}}, status: 422
    end
  end

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
end

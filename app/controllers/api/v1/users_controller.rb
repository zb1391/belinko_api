require_relative "../../../../lib/omniauth/facebook.rb"

class Api::V1::UsersController < ApplicationController
  respond_to :json

  def show
    respond_with User.find(params[:id])
  end

  def create
    begin
      user_creds = Omniauth::Facebook.authenticate(params[:code])
      @user = User.from_omniauth(user_creds)
      if @user.persisted?
        @user.update_auth_token(user_creds["token"])
        sign_in @user, event: :authentication
        render json: user_creds, status: 201
      else
        raise "Failed to Log in"
      end
    rescue
      render json: { errors: { facebook: "Failed to log in" } }, status: 422
    end
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render json: user, status: 200, location: [:api,user]
    else
      render json: {errors: user.errors}, status: 422
    end
  end


  def destroy
    user = User.find(params[:id])

    user.destroy
    head 204
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end

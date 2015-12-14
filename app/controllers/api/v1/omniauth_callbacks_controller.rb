class Api::V1::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # finds the user or creates one
    @user = User.from_omniauth(request.env["omniauth.auth"])


    if @user.persisted?
      @user.update_auth_token(request.env["omniauth.auth"].credentials.token)
      sign_in @user, event: :authentication
 
      # return the omni-auth data in the response
      # including the user's uid and the auth-token
      render json: request.env['omniauth.auth'], status: 201 
    else
      render json: {errors: {facebook: "Failed to log in"}}, status: 422
    end
  end

  def failure
    render json: {errors: {facebook: "Failed to log in"}}, status: 422
  end
end

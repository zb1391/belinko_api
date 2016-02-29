require 'httparty'
require_relative "./response_error.rb"
require_relative "./permission_error.rb"

module Omniauth
  class Facebook
    include HTTParty

    # The base uri for facebook graph API
    base_uri 'https://graph.facebook.com/v2.3'

    # Used to authenticate app with facebook user
    # Usage
    #   Omniauth::Facebook.authenticate('authorization_code')
    # Flow
    #   Retrieve access_token from authorization_code
    #   Retrieve User_Info hash from access_token
    def self.authenticate(code)
      provider = self.new
      access_token = provider.get_access_token(code)
      user_info    = provider.get_user_profile(access_token)
      creds = {
        "provider" => "facebook",
        "uid" => user_info["id"],
        "name" => user_info["name"],
        "token" => access_token
      }
      return creds
    end

    # Used to revoke the application permissions and login if a user
    # revoked some of the mandatory permissions required by the application
    # like the email
    # Usage
    #    Omniauth::Facebook.deauthorize('user_id')
    # Flow
    #   Send DELETE /me/permissions?access_token=XXX
    def self.deauthorize(access_token)
      options  = { query: { access_token: access_token } }
      response = self.delete('/me/permissions', options)

      # Something went wrong most propably beacuse of the connection.
      unless response.success?
        Rails.logger.error 'Omniauth::Facebook.deauthorize Failed'
        fail Omniauth::ResponseError, 'errors.auth.facebook.deauthorization'
      end
      response.parsed_response
    end

    def get_access_token(code)
      response = self.class.get('/oauth/access_token', query(code))

      # Something went wrong either wrong configuration or connection
      unless response.success?
        Rails.logger.error 'Omniauth::Facebook.get_access_token Failed'
        fail Omniauth::ResponseError, 'errors.auth.facebook.access_token'
      end
      response.parsed_response['access_token']
    end

    def get_user_profile(access_token)
      options = { query: { access_token: access_token } }
      response = self.class.get('/me', options)

      # Something went wrong most propably beacuse of the connection.
      unless response.success?
        Rails.logger.error 'Omniauth::Facebook.get_user_profile Failed'
        fail Omniauth::ResponseError, 'errors.auth.facebook.user_profile'
      end
      response.parsed_response
    end

    private

    # access_token required params
    # https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/v2.3#confirm
    def query(code)
      {
        query: {
          code: code,
          redirect_uri: "http://localhost:4000/login",
          client_id: "561265827354748",
          client_secret: "ebb4ed4353b0e928c0b1093daab7b8af"
        }
      }
    end
  end
end

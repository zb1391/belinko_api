require 'sinatra/base'

class FakeFacebookGraph < Sinatra::Base
  get '/:version/oauth/access_token' do
    respond_json 200, 'facebook_access_token.json'
  end

  get '/:version/me' do
    respond_json 200, 'facebook_me.json'
  end

  def respond_json(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end

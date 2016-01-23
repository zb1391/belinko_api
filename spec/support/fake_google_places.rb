require 'sinatra/base'

class FakeGooglePlaces < Sinatra::Base
  get '/maps/api/place/radarsearch/json' do
    respond_json 200, 'radarsearch.json'
  end

  get '/maps/api/place/nearbysearch/json' do
    respond_json 200, 'nearbysearch.json'
  end

  private

  def respond_json(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end

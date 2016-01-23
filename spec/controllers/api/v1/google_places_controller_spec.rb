require 'spec_helper'

RSpec.describe Api::V1::GooglePlacesController, type: :controller do
  describe "GET #radar_search" do
    describe "when both lat and long are missing params" do
      before(:each) do
        get :radar_search
      end
      it { should respond_with 400 }

      it "returns a lat error" do
        resp = json_response
        expect(resp[:errors][:lat]).to eql("lat is required")
      end

      it "returns a long error" do
        resp = json_response
        expect(resp[:errors][:long]).to eql("long is required")
      end
    end
  end
end

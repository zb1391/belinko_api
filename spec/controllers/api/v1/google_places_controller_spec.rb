require 'spec_helper'

RSpec.describe Api::V1::GooglePlacesController, type: :controller do
  describe "GET #radar_search" do
    describe "when both latitude and longitude are missing params" do
      before(:each) do
        get :radar_search
      end
      it { should respond_with 200 }

      it "returns a lat error" do
        resp = json_response
        expect(resp[:errors][:latitude]).to eql("latitude is a required option")
      end

      it "returns a long error" do
        resp = json_response
        expect(resp[:errors][:longitude]).to eql("longitude is a required option")
      end
    end

    describe "when latitude and longitude are present" do
      before(:each) do
        get :radar_search, { latitude: 47, longitude: 47 }
      end

      it { should respond_with 200 }

      it "returns an array of places" do
        resp = json_response
        expect(resp[:places].empty?).to eql(false)
      end
    end
  end
end

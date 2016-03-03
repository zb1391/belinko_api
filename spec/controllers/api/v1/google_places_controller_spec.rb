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

  describe "GET #nearby_search" do
    describe "when both latitude and longitude are missing params" do
      before(:each) do
        get :nearby_search
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
        get :nearby_search, { latitude: 47, longitude: 47 }
      end

      it { should respond_with 200 }

      it "returns an array of places" do
        resp = json_response
        expect(resp[:places].empty?).to eql(false)
      end
    end
  end

  describe "GET #text_search" do
    describe "when query is a missing param" do
      before(:each) do
        get :text_search
      end
      it { should respond_with 200 }

      it "returns a query error" do
        resp = json_response
        expect(resp[:errors][:query]).to eql("query is a required option")
      end
    end

    describe "when query is present" do
      before(:each) do
        get :text_search, { query: 'test' }
      end

      it { should respond_with 200 }

      it "returns an array of places" do
        resp = json_response
        expect(resp[:places].empty?).to eql(false)
      end
    end
  end

  describe "GET #detail" do
    describe "when query is missing a param" do
      before(:each) do
        get :detail
      end

      it { should respond_with 200 }

      it "returns an id error" do
        resp = json_response
        expect(resp[:errors][:id]).to eql("id is a required option")
      end
    end

    describe "when id is present" do
      before(:each) do
        get :detail, { id: "123" }
      end

      it { should respond_with 200 }

      it "returns a place response" do
        resp = json_response
        expect(resp[:place].empty?).to eql(false)
      end
    end
  end
end

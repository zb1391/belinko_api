require 'spec_helper'

RSpec.describe Place, type: :model do

  let(:place) { FactoryGirl.build :place }
  subject { place }

  it { should respond_to(:name) }
  it { should respond_to(:latitude) }
  it { should respond_to(:longitude) }
  it { should respond_to(:gid) }
  it { should respond_to(:likes) }
  it { should respond_to(:dislikes) }

  it { should validate_presence_of :latitude }
  it { should validate_presence_of :longitude }
  it { should validate_presence_of :name }
  it { should validate_presence_of :gid }

  it { should have_many(:reviews) }
  it { should have_many(:users) }


  describe "review associations" do
    before do
      @user = FactoryGirl.create :user, uid: "456", provider: "facebook"
      @place = FactoryGirl.create :place
      3.times { FactoryGirl.create :review, user: @user, place: @place }
    end

    it "destroys the associated reviews when the place is destroyed" do
      reviews = @place.reviews
      @place.destroy
      reviews.each do |review|
        expect(Review.find(review)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "#as_google_json" do
    before(:each) do
      @place = FactoryGirl.build :place, name: 'test', latitude: 123, longitude: '456', gid: '111'
      @expected = { 
        "place_id" => @place.gid,
        "name" => @place.name,
        "geometry" => {"lat" => @place.latitude, "lng" => @place.longitude}
      }
    end

    it "returns the expected json" do
      expect(@place.as_google_json).to eql(@expected)
    end
  end

  describe "#update_recommendations" do
    it "increments likes when true" do
      place = FactoryGirl.build :place, would_recommend: true
      place.update_recommendations
      expect(place.likes).to eql(1)
    end

    it "increments dislikes when false" do
      place = FactoryGirl.build :place, would_recommend: false
      place.update_recommendations
      expect(place.dislikes).to eql(1)
    end
  end

  describe "#reviewed_by" do
    before(:each) do
      @user = FactoryGirl.create :user
      @place = FactoryGirl.create :place
      @review = FactoryGirl.create :review, place_id: @place.id, user_id: @user.id
    end

    it "returns the place" do
      res = Place.reviewed_by([@user.id])
      expect(res.first).to eql(@place)
    end
  end
end

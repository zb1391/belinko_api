require 'spec_helper'

RSpec.describe Place, type: :model do

  let(:place) { FactoryGirl.build :place }
  subject { place }

  it { should respond_to(:name) }
  it { should respond_to(:latitude) }
  it { should respond_to(:longitude) }
  it { should respond_to(:gid) }

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
end

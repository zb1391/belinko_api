require 'spec_helper'

RSpec.describe Review, type: :model do

  let(:review) { FactoryGirl.build :review }
  subject { review }

  it { should respond_to(:comment) }
  it { should respond_to(:would_recommend) }
  it { should validate_presence_of :comment }
  it { should validate_presence_of :user }
#  it { should validate_presence_of :place_id }

  it { should belong_to :user }
  it { should belong_to :place }

  describe "#reviewed_by" do
    before(:each) do
      @user = FactoryGirl.create :user
      place = FactoryGirl.create :place
      3.times do
        FactoryGirl.create :review, user: @user, place: place
      end
      another = FactoryGirl.create :user
      FactoryGirl.create :review, user: another, place: place
    end

    it "returns reviews created by a particular user" do
      expect(Review.reviewed_by(@user.id).count).to eql(3)
    end
  end
end

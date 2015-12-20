require 'spec_helper'

RSpec.describe Place, type: :model do

  let(:place) { FactoryGirl.build :place }
  subject { place }

  it { should respond_to(:name) }
  it { should respond_to(:latitude) }
  it { should respond_to(:longitude) }
  it { should respond_to(:lat_long) }


  it { should validate_presence_of :latitude }
  it { should validate_presence_of :longitude }
  it { should validate_presence_of :name }
  
  it { should validate_uniqueness_of :latitude }
  it { should validate_uniqueness_of :longitude }

end

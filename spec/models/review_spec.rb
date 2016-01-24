require 'spec_helper'

RSpec.describe Review, type: :model do

  let(:review) { FactoryGirl.build :review }
  subject { review }

  it { should respond_to(:comment) }

  it { should validate_presence_of :comment }
  it { should validate_presence_of :user }
#  it { should validate_presence_of :place_id }

  it { should belong_to :user }
  it { should belong_to :place }

end

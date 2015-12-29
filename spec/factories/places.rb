FactoryGirl.define do
  factory :place do
    name "My Place"
    sequence(:latitude)  { |n| n }
    sequence(:longitude) { |n| n }
  end

end

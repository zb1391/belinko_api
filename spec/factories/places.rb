FactoryGirl.define do
  factory :place do
    name "My Place"
    sequence(:latitude)  { |n| "100#{n}" }
    sequence(:longitude) { |n| "800#{n}" }
  end

end

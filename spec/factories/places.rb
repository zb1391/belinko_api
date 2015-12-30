FactoryGirl.define do
  factory :place do
    name "My Place"
    sequence(:latitude)  { |n| n }
    sequence(:longitude) { |n| n }
    sequence(:gid)       { |n| n }
  end

end

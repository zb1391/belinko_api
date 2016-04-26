FactoryGirl.define do
  factory :review do
    comment "MyText"
    would_recommend true
    user
    place
  end

end

FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password "12345678"
    password_confirmation "12345678"
    sequence(:uid) { |n| n }
    sequence(:auth_token) { |n| "#{n}" }
  end

end

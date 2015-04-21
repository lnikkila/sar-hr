FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.safe_email(name) }
    password   { Faker::Internet.password }

    factory :admin do
      role :admin
    end
  end
end

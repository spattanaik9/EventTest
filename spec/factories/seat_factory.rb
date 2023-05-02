FactoryBot.define do
  factory :seat do
    association :event

    category { Faker::Lorem.word }
    total_count { Faker::Number.digit }
    price { Faker::Number.positive }
  end
end
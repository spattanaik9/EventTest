FactoryBot.define do
  factory :referral_reward do
    association :event

    reward { Faker::Lorem.word }
    min_count { Faker::Number.non_zero_digit }
  end
end
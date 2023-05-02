FactoryBot.define do
  factory :guest_referral_reward do
    association :guest
    association :referral_reward

    count { Faker::Number.digit }
  end
end
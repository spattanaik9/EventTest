require 'rails_helper'

RSpec.describe GuestReferralReward, type: :model do
  it "fails if count is negative" do
    guest_referral_reward = build(:guest_referral_reward, count: -Faker::Number.non_zero_digit)
    expect(guest_referral_reward).to_not be_valid
  end

  it "fails if count is not an integer" do
    guest_referral_reward = build(:guest_referral_reward, count: -Faker::Number.positive)
    expect(guest_referral_reward).to_not be_valid
  end

  it "fails if count is nil" do
    guest_referral_reward = build(:guest_referral_reward, count: nil)
    expect(guest_referral_reward).to_not be_valid
  end

  it "has a valid model with guest and referral reward associations" do
    user = build :user, id: 1
    event = build :event, id: 1, user: user
    guest = build :guest, id: 1, event: event, user: user
    reward = build :referral_reward, id: 1, event: event

    guest_referral_reward = build :guest_referral_reward, guest: guest, referral_reward: reward
    expect(guest_referral_reward).to be_valid
  end
end
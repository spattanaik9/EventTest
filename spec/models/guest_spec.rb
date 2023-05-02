require 'rails_helper'

RSpec.describe Guest, type: :model do
  it "fails without email" do
    guest = build(:guest, email: nil)
    expect(guest).to_not be_valid
  end

  it "fails if invite expiration has already passed" do
    guest = build(:guest, invite_expiration: Faker::Date.backward)
    expect(guest).to_not be_valid
  end

  it "fails if referral expiration has already passed" do
    guest = build(:guest, referral_expiration: Faker::Date.backward)
    expect(guest).to_not be_valid
  end

  it "sets the booked status even if booked is not set" do
    user = build :user, id: 1
    event = build :event, id: 1, user: user
    guest = build :guest, event: event, user: user, booked: nil
    expect(guest).to be_valid
  end

  it "has a valid model with at least email, booked status, and added_by" do
    user = build :user, id: 1
    event = build :event, id: 1, user: user

    g_attr = attributes_for(:guest).except(:first_name, :last_name, :invite_expiration, :referral_expiration, :invited_at)
    guest = build :guest, event: event, user: user, **g_attr
    expect(guest).to be_valid
  end
end

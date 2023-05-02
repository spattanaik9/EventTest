require 'rails_helper'

RSpec.describe "Api::V1::ReferralRewardsController", type: :request do
  let!(:event) { create :event }
  let!(:rewards) { create_list :referral_reward, 3, event: event }

  describe "GET /api/v1/events/:event_id/rewards" do
    it "gets all rewards under the event" do
      get "/api/v1/events/#{event.id}/rewards"
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")

      resb = JSON.parse response.body
      expect(resb.length).to be == 3
      expect(resb[0]).to include("reward", "min_count")
    end

    it "gets paginated set of rewards under the event" do
      get "/api/v1/events/#{event.id}/rewards", params: {offset: 0, limit: 2}
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")

      resb = JSON.parse response.body
      expect(resb.length).to be == 2
      expect(resb[0, 1]).to match(rewards[0, 1].map {|s| s.attributes})

      get "/api/v1/events/#{event.id}/rewards", params: {offset: 2, limit: 2}
      resb = JSON.parse response.body
      expect(resb[0]).to match(rewards[2].attributes)
    end
  end

  describe "GET /api/v1/events/:event_id/rewards/:id" do
    it "returns a success response" do
      get "/api/v1/events/#{event.id}/rewards/#{rewards[0].id}"
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")

      resb = JSON.parse response.body
      expect(resb).to include("reward", "min_count")
    end
  end

  describe "GET /api/v1/events/:event_id/refer" do
    let!(:event) { create :event }
    let!(:reward) { create :referral_reward, event: event}
    let!(:guest) { create :guest, event: event}
    let!(:grr) { create :guest_referral_reward, guest: guest, referral_reward: reward }

    it "increases the count when visiting a guest's referral link" do
      get "/api/v1/events/#{event.id}/refer?guest_id=#{guest.id}"
      expect(response).to be_successful

      get "/api/v1/events/#{event.id}/rewards/#{reward.id}?guest_id=#{guest.id}"
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")

      resb = JSON.parse response.body
      expect(resb["count"]).to eq grr.count+1
    end
  end

  describe "POST /api/v1/events/:event_id/rewards" do
    let!(:event) { create :event }
    it "creates a new reward" do
      p = attributes_for :referral_reward
      prior_count = ReferralReward.count

      post "/api/v1/events/#{event.id}/rewards", params: p
      expect(response).to be_successful
      expect(ReferralReward.count).to eq prior_count+1
    end

    it "fails with invalid arguments" do
      p = attributes_for :referral_reward, min_count: -1
      post "/api/v1/events/#{event.id}/rewards", params: p
      expect(response).to_not be_successful
    end
  end

  context "there is an event with a referral reward" do
    let!(:event) { create :event }
    let!(:reward) { create :referral_reward, event: event, min_count: 0 }
    describe "PATCH /api/v1/events/:event_id/rewards/:id" do
      it "updates the requested reward" do
        p = attributes_for :referral_reward, id: nil, min_count: 10
        patch "/api/v1/events/#{event.id}/rewards/#{reward.id}", params: p
        expect(response).to be_successful

        reward.reload
        expect(reward.min_count).to eq 10
      end
    end

    describe "DELETE /api/v1/events/:event_id/rewards/:id" do
      it "destroys the requested reward" do
        expect {
          delete "/api/v1/events/#{event.id}/rewards/#{reward.id}"
        }.to change { ReferralReward.count }.by(-1)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Api::V1::UsersController", type: :request do
  let!(:users) { create_list :user, 3}

  describe "GET /api/v1/users" do
    it "gets all users" do
      get "/api/v1/users"
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")

      resb = JSON.parse response.body
      expect(resb.length).to be == 3
      expect(resb[0]).to include("email")
    end

    it "gets paginated set of users under the event" do
      get "/api/v1/users", params: {offset: 0, limit: 2}
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")

      resb = JSON.parse response.body
      expect(resb.length).to be == 2
      expect(resb[0, 1].map {|u| u[:email]}).to match(users[0, 1].map {|u| u.attributes[:email]})

      get "/api/v1/users", params: {offset: 2, limit: 2}
      resb = JSON.parse response.body
      expect(resb[0][:email]).to match(users[2].attributes[:email])
    end
  end

  describe "GET /api/v1/users/:id" do
    it "returns a success response" do
      get "/api/v1/users/#{users[0].id}"
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")

      resb = JSON.parse response.body
      expect(resb).to include("email")
    end
  end

  describe "DELETE /api/v1/users/:id" do
    it "destroys the requested user" do
      expect {
        delete "/api/v1/users/#{users[0].id}"
      }.to change { User.count }.by(-1)
    end
  end
end

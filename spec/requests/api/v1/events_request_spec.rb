require 'rails_helper'

RSpec.describe "Api::V1::EventsController", type: :request do
  describe "GET /api/v1/events" do
    let!(:user) { create :user }
    let!(:event_list) { create_list :event, 3, user: user}

    it "should return a json list of all events" do
      get '/api/v1/events', params: { user_id: user.id }
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
      
      events = JSON.parse response.body
      expect(events.length).to be == 3
      expect(events[0]).to include("title", "datetime", "address", "description")
    end
  end

  describe 'POST /api/v1/events' do
    it 'should create a new event' do
      p = attributes_for(:event)
      post '/api/v1/events', params: p
      expect(response).to be_successful
    end

    context 'user uploads a file in image field' do
      it 'should accept with images under the image parameter' do
        p = attributes_for(:event, image: fixture_file_upload('img/jpg/img-64x64.jpg', 'image/jpeg'))
        post '/api/v1/events', params: p
        expect(response).to be_successful
      end

      it 'should reject events with non-image file types under the image parameter' do
        p = attributes_for(:event, image: fixture_file_upload('txt/random/random.txt', 'text/plain'))
        post '/api/v1/events', params: p
        expect(response).to_not be_successful
      end
    end

    context 'user uploads a file in boxoffice field' do
      it 'should accept events with spreadsheet file types under the box_office parameter' do
        p = attributes_for(:event, box_office: fixture_file_upload('spreadsheet/test.csv', 'text/csv'))
        post '/api/v1/events', params: p
        expect(response).to be_successful
      end

      it 'should reject events with non-spreadsheet file types under the box_office parameter' do
        p = attributes_for(:event, box_office: fixture_file_upload('txt/random/random.txt', 'text/plain'))
        post '/api/v1/events', params: p
        expect(response).to_not be_successful
      end
    end
  end

  describe 'PATCH /api/v1/events/:id' do
    let!(:event) { create :event }

    context 'user uploads a new file in the boxoffice field' do
      it 'should accept events with spreadsheet file types under the box_office parameter' do
        p = {box_office: fixture_file_upload('spreadsheet/test.csv', 'text/csv')}
        patch "/api/v1/events/#{event.id}", params: p
        expect(response).to be_successful
      end

      it 'should reject events with non-spreadsheet file types under the box_office parameter' do
        p = {box_office: fixture_file_upload('txt/random/random.txt', 'text/plain')}
        patch "/api/v1/events/#{event.id}", params: p
        expect(response).to_not be_successful
      end
    end
  end

  describe 'DELETE /api/v1/events/:id' do
    context 'there is an event' do
      let!(:event) { create :event }
      it 'should delete an existing record' do
        prior_count = Event.count
        delete "/api/v1/events/#{event.id}"
        expect(response).to be_successful
        expect(Event.count).to eq prior_count-1
      end
    end
  end
end

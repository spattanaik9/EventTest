require 'rails_helper'

RSpec.describe "Api::V1::TicketsController", type: :request do
  describe "GET /api/v1/events/:event_id/guests/:guest_id/tickets" do
    context "there is an event with a guest, seats, and allocated tickets" do
      let!(:event) { create :event }
      let!(:guest) { create :guest, event: event }
      let!(:seats) { create_list :seat, 3, event: event }
      let!(:ticket) { 
        seats.map { | seat |
          create :guest_seat_ticket, guest: guest, seat: seat
        }
      }

      it 'should get a list of tickets under the guest' do
        get "/api/v1/events/#{event.id}/guests/#{guest.id}/tickets"

        expect(response).to be_successful
        expect(response.content_type).to eq("application/json; charset=utf-8")

        tickets = JSON.parse response.body
        expect(tickets.length).to be == 3
        expect(tickets[0]).to include("guest_id", "seat_id")
      end
    end
  end

  describe 'POST /api/v1/events/:event_id/guests' do
    context "there is an event with a guest and seats" do
      let!(:event) { create :event }
      let!(:guest) { create :guest, event: event }
      let!(:seat) { create :seat, event: event }

      it 'should create an ticket under the guest' do
        p = attributes_for :guest_seat_ticket, guest_id: guest.id, seat_id: seat.id
        post "/api/v1/events/#{event.id}/guests/#{guest.id}/tickets", params: p
        expect(response).to be_successful
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe 'PATCH /api/v1/events/:event_id/guests' do
    context "there is an event with a guest, seat, and tickets" do
      let!(:event) { create :event }
      let!(:guest) { create :guest, event: event }
      let!(:seat) { create :seat, event: event }
      let!(:ticket) { create :guest_seat_ticket, guest: guest, seat: seat }

      it 'should update an ticket under the guest' do
        p = attributes_for :guest_seat_ticket, guest_id: guest.id, seat_id: seat.id
        patch "/api/v1/events/#{event.id}/guests/#{guest.id}/tickets", params: p
        expect(response).to be_successful
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe 'DELETE /api/v1/events/:event_id/guests' do
    context "there is an event with a guest" do
      let!(:event) { create :event }
      let!(:guest) { create :guest, event: event }
      context "there is a single ticket" do
        let!(:seat) { create :seat, event: event }
        let!(:ticket) { create :guest_seat_ticket, guest: guest, seat: seat }

        it 'should delete an ticket under the guest with seat_id' do
          p = { seat_id: seat.id }
          expect {
            delete "/api/v1/events/#{event.id}/guests/#{guest.id}/tickets", params: p 
          }.to change { GuestSeatTicket.count }.by(-1)
        end
      end

      context "there are multiple tickets" do
        let!(:seats) { create_list :seat, 3, event: event }
        let!(:tickets) { 
          seats.map { |seat|
            create :guest_seat_ticket, guest: guest, seat: seat
          }
        }
        it 'should delete all tickets under the guest' do
          expect {
            delete "/api/v1/events/#{event.id}/guests/#{guest.id}/tickets"
          }.to change { GuestSeatTicket.count }.to be == 0
        end
      end
    end
  end
end

json.extract! seating_type, :id, :seat_category, :total_seat_count, :vip_seat_count, :box_office_seat_count, :balance_seats, :event_id, :created_at, :updated_at
json.url seating_type_url(seating_type, format: :json)

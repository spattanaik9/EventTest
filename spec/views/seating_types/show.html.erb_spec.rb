require 'rails_helper'

RSpec.describe "seating_types/show", type: :view do
  before(:each) do
    @seating_type = assign(:seating_type, SeatingType.create!(
      :seat_category => "Seat Category",
      :total_seat_count => 2,
      :vip_seat_count => 3,
      :box_office_seat_count => 4,
      :balance_seats => 5,
      :event => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Seat Category/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(//)
  end
end

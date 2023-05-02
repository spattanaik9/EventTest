class CreateSeatCategoryDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :seat_category_details do |t|
      t.string :event_title
      t.string :seat_category
      t.integer :total_seats
      t.integer :vip_seats
      t.integer :non_vip_seats
      t.integer :balance
    end
  end
end

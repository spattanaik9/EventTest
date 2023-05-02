class GuestCheckin < ActiveRecord::Migration[7.0]
  def change
    add_column :guests, :checked, :boolean, default: false
  end
end

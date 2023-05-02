class Referral < ActiveRecord::Migration[7.0]
  def change
    create_table :guest_referrals, force: :cascade do |t|
      t.references :guest, null: false, foreign_key: true
      t.string :email, null: false, index: true
      t.boolean :counted, null: false, default: false
    end
    remove_column :events, :last_modified, :datetime
    add_timestamps(:events)
  end
end

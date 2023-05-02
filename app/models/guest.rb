class Guest < ApplicationRecord
  belongs_to :event
  belongs_to :user, foreign_key: :added_by

  has_many :guest_seat_tickets, dependent: :destroy
  has_many :guest_referrals, dependent: :destroy
  has_many :guest_referral_rewards, dependent: :destroy
  has_many :seats, through: :guest_seat_tickets, dependent: :destroy
  has_many :referral_rewards, through: :guest_referral_rewards, dependent: :destroy

  attribute :booked, :boolean, default: false
  attribute :checked, :boolean, default: false
  
  validates :email, presence: true, uniqueness: { scope: :event }
  validates :booked, inclusion: [true, false, nil]
  validates :added_by, presence: true
  validates :referral_expiration, expiration: true
  validate :checked_only_if_booked

  def checked_only_if_booked
    return if (booked || !checked)
    errors.add(:checked, "can't be true if guest hasn't booked")
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.to_csv
    guests = all
    CSV.generate(headers: true) do |csv|
      # cols = [:last_name, :first_name, :email, :added_by, :affiliation, :perks, :comments, :type,
      #     :booked, :invited_at, :invite_expiration, :referral_expiration]
      cols = [:first_name, :last_name, :email, :affiliation, :perks, :comments, 
              :type, :seat_category, :allotted, :committed, :guestcommitted, :status]
      csv << cols
      guests.each do |guest|
        guest.guest_seat_tickets.each do |ticket|
          user_email = guest.user.email
          gattr = guest.attributes.symbolize_keys.to_h
          gattr[:added_by] = guest.user.email
          gattr[:status] = guest.booked ? 'X' : ''
          # gattr[:allotted] = guest.guest_seat_tickets.allotted
          
          gattr[:seat_category] = ticket.seat.category
          gattr[:allotted] = ticket.allotted
          gattr[:committed] = ticket.committed
          
          csv << gattr.values_at(*cols)
        end
      end
    end
  end
  
  
end

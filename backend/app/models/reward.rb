class Reward < ApplicationRecord
  has_many :redemptions, dependent: :restrict_with_error
  has_many :redeemed_by_users, through: :redemptions, source: :user
  
  validates :name, presence: true
  validates :description, presence: true
  validates :cost, presence: true, numericality: { greater_than: 0 }
end
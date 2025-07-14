class User < ApplicationRecord
  has_secure_password
  
  has_many :redemptions, dependent: :destroy
  has_many :redeemed_rewards, through: :redemptions, source: :reward
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :points_balance, numericality: { greater_than_or_equal_to: 0 }
  
  before_save :downcase_email
  
  def can_afford?(reward)
    points_balance >= reward.cost
  end
  
  def deduct_points!(amount)
    # Use row-level locking to prevent race conditions in concurrent redemptions
    with_lock do
      raise "Insufficient points" if points_balance < amount
      update!(points_balance: points_balance - amount)
    end
  end
  
  private
  
  def downcase_email
    self.email = email&.downcase
  end
end
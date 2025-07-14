class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward
  
  validates :user_id, presence: true
  validates :reward_id, presence: true
end
module Rewards
  class Redeemer
    class InsufficientPointsError < StandardError; end
    class RewardNotFoundError < StandardError; end
    
    def initialize(user:, reward_id:)
      @user = user
      @reward_id = reward_id
    end
    
    def call
      # Lock user record to ensure atomic check-and-deduct operation
      @user.with_lock do
        reward = Reward.find_by(id: @reward_id)
        raise RewardNotFoundError, "Reward not found" unless reward
        
        unless @user.can_afford?(reward)
          raise InsufficientPointsError, "Insufficient points to redeem this reward"
        end
        
        # Deduct points and create redemption in same transaction
        @user.deduct_points!(reward.cost)
        redemption = @user.redemptions.create!(reward: reward)
        
        { success: true, redemption: redemption }
      end
    rescue InsufficientPointsError, RewardNotFoundError => e
      { success: false, error: e.message }
    end
  end
end
class RewardsController < ApplicationController
  def index
    rewards = Reward.all
    render_serialized(rewards, RewardSerializer)
  end
end
require 'rails_helper'

RSpec.describe Rewards::Redeemer, type: :service do
  let(:user) { create(:user, points_balance: 1000) }
  let(:reward) { create(:reward, cost: 500) }
  let(:expensive_reward) { create(:reward, cost: 1500) }

  describe '#call' do
    context 'when user has sufficient points' do
      it 'creates a redemption and deducts points' do
        redeemer = described_class.new(user: user, reward_id: reward.id)
        
        result = nil
        expect { result = redeemer.call }.to change { user.redemptions.count }.by(1)
        
        expect(result[:success]).to be true
        expect(result[:redemption]).to be_a(Redemption)
        
        user.reload
        expect(user.points_balance).to eq(500)
      end
    end

    context 'when user has insufficient points' do
      it 'returns failure without creating redemption' do
        redeemer = described_class.new(user: user, reward_id: expensive_reward.id)
        
        expect { redeemer.call }.not_to change { user.redemptions.count }
        
        result = redeemer.call
        expect(result[:success]).to be false
        expect(result[:error]).to eq("Insufficient points to redeem this reward")
        
        user.reload
        expect(user.points_balance).to eq(1000)
      end
    end

    context 'when reward does not exist' do
      it 'returns failure' do
        redeemer = described_class.new(user: user, reward_id: 999)
        
        result = redeemer.call
        expect(result[:success]).to be false
        expect(result[:error]).to eq("Reward not found")
      end
    end
  end

  describe 'race condition protection' do
    let(:race_reward) { create(:reward, cost: 600) }
    let(:race_user) { create(:user, points_balance: 600) }
    
    it 'prevents double redemption when called multiple times' do
      # First redemption should succeed
      redeemer1 = described_class.new(user: race_user, reward_id: race_reward.id)
      result1 = redeemer1.call
      
      expect(result1[:success]).to be true
      
      # Second redemption should fail due to insufficient points
      race_user.reload
      redeemer2 = described_class.new(user: race_user, reward_id: race_reward.id)
      result2 = redeemer2.call
      
      expect(result2[:success]).to be false
      expect(result2[:error]).to eq("Insufficient points to redeem this reward")
      
      # User should have 0 points and 1 redemption
      race_user.reload
      expect(race_user.points_balance).to eq(0)
      expect(race_user.redemptions.count).to eq(1)
    end
  end
end
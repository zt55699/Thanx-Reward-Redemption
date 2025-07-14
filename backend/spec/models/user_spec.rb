require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_numericality_of(:points_balance).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:redemptions).dependent(:destroy) }
    it { is_expected.to have_many(:redeemed_rewards).through(:redemptions) }
  end

  describe '#can_afford?' do
    subject { create(:user, points_balance: 500) }
    let(:affordable_reward) { create(:reward, cost: 300) }
    let(:expensive_reward) { create(:reward, cost: 600) }

    it 'returns true when user has enough points' do
      expect(subject.can_afford?(affordable_reward)).to be true
    end

    it 'returns false when user does not have enough points' do
      expect(subject.can_afford?(expensive_reward)).to be false
    end
  end

  describe '#deduct_points!' do
    subject { create(:user, points_balance: 500) }

    it 'deducts points when user has enough' do
      subject.deduct_points!(200)
      expect(subject.reload.points_balance).to eq(300)
    end

    it 'raises error when user does not have enough points' do
      expect { subject.deduct_points!(600) }.to raise_error("Insufficient points")
    end
  end

  describe 'email normalization' do
    let(:user) { create(:user, email: 'TEST@THANX.COM') }
    
    it 'downcases email before saving' do
      expect(user.email).to eq('test@thanx.com')
    end
  end
end
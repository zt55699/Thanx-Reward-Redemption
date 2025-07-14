require 'rails_helper'

RSpec.describe Redemption, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }
    let(:reward) { create(:reward) }
    
    subject { Redemption.new(user: user, reward: reward) }
    
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:reward) }
  end

  describe 'scopes' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:redemption1) { create(:redemption, user: user1) }
    let!(:redemption2) { create(:redemption, user: user2) }

    it 'can be scoped by user' do
      user_redemptions = described_class.where(user: user1)
      expect(user_redemptions).to include(redemption1)
      expect(user_redemptions).not_to include(redemption2)
    end
  end
end
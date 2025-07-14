require 'rails_helper'

RSpec.describe Reward, type: :model do
  subject { build(:reward) }

  describe 'validations' do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:cost) }
    it { is_expected.to validate_numericality_of(:cost).is_greater_than(0) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:redemptions).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:redeemed_by_users).through(:redemptions) }
  end
end
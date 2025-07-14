require 'rails_helper'

RSpec.describe RedemptionPolicy do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:redemption) { create(:redemption, user: user) }

  describe '#index?' do
    subject { described_class.new(user, redemption) }

    it 'allows authenticated users to view redemptions' do
      expect(subject.index?).to be true
      expect(described_class.new(admin, redemption).index?).to be true
    end

    context 'when user is unauthenticated' do
      subject { described_class.new(nil, redemption) }
      
      it 'denies access' do
        expect(subject.index?).to be false
      end
    end
  end

  describe '#create?' do
    subject { described_class.new(user, Redemption) }

    it 'allows regular users to create redemptions' do
      expect(subject.create?).to be true
    end

    context 'when user is admin' do
      subject { described_class.new(admin, Redemption) }
      
      it 'denies access' do
        expect(subject.create?).to be false
      end
    end

    context 'when user is unauthenticated' do
      subject { described_class.new(nil, Redemption) }
      
      it 'denies access' do
        expect(subject.create?).to be false
      end
    end
  end

  describe RedemptionPolicy::Scope do
    let!(:user_redemption) { create(:redemption, user: user) }
    let!(:other_redemption) { create(:redemption, user: other_user) }

    context 'for regular users' do
      subject { RedemptionPolicy::Scope.new(user, Redemption) }

      it 'shows only user own redemptions' do
        scope = subject.resolve
        expect(scope).to include(user_redemption)
        expect(scope).not_to include(other_redemption)
      end
    end

    context 'for admin users' do
      subject { RedemptionPolicy::Scope.new(admin, Redemption) }

      it 'shows all redemptions' do
        scope = subject.resolve
        expect(scope).to include(user_redemption)
        expect(scope).to include(other_redemption)
      end
    end
  end
end
require 'rails_helper'

RSpec.describe ApplicationPolicy do
  let(:user) { create(:user) }
  let(:record) { double('record') }
  
  subject { described_class.new(user, record) }

  describe 'permissions' do
    it 'denies all actions by default' do
      expect(subject.index?).to be false
      expect(subject.show?).to be false
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end
  end

  describe '#admin_user?' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }

      it 'returns true' do
        expect(subject.send(:admin_user?)).to be true
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user, admin: false) }

      it 'returns false' do
        expect(subject.send(:admin_user?)).to be false
      end
    end

    context 'when user is nil' do
      let(:user) { nil }

      it 'returns false' do
        expect(subject.send(:admin_user?)).to be false
      end
    end
  end

  describe ApplicationPolicy::Scope do
    subject { ApplicationPolicy::Scope.new(user, double) }

    it 'raises NotImplementedError by default' do
      expect { subject.resolve }.to raise_error(NotImplementedError)
    end
  end
end
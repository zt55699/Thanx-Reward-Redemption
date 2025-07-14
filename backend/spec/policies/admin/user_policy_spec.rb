require 'rails_helper'

RSpec.describe Admin::UserPolicy do
  let(:regular_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  let(:target_user) { create(:user) }

  describe 'admin permissions' do
    %w[index? show? create? update? destroy? balances? adjust_balances?].each do |permission|
      describe "##{permission}" do
        context 'when user is regular user' do
          subject { described_class.new(regular_user, target_user) }
          
          it 'denies access' do
            expect(subject.send(permission)).to be false
          end
        end

        context 'when user is admin' do
          subject { described_class.new(admin_user, target_user) }
          
          it 'grants access' do
            expect(subject.send(permission)).to be true
          end
        end

        context 'when user is nil' do
          subject { described_class.new(nil, target_user) }
          
          it 'denies access' do
            expect(subject.send(permission)).to be false
          end
        end
      end
    end
  end

  describe Admin::UserPolicy::Scope do
    let(:scope) { User.all }

    context 'when user is admin' do
      subject { Admin::UserPolicy::Scope.new(admin_user, scope) }
      
      it 'returns all users' do
        expect(subject.resolve).to eq(scope.all)
      end
    end

    context 'when user is not admin' do
      subject { Admin::UserPolicy::Scope.new(regular_user, scope) }
      
      it 'returns no users' do
        expect(subject.resolve).to eq(scope.none)
      end
    end
  end
end
require 'rails_helper'

RSpec.describe UserPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

  describe 'user-specific permissions' do
    %w[show? update? balances?].each do |permission|
      describe "##{permission}" do
        context 'when user owns the record' do
          subject { described_class.new(user, user) }
          
          it 'grants access' do
            expect(subject.send(permission)).to be true
          end
        end

        context 'when user does not own the record' do
          subject { described_class.new(user, other_user) }
          
          it 'denies access' do
            expect(subject.send(permission)).to be false
          end
        end

        context 'when user is nil' do
          subject { described_class.new(nil, user) }
          
          it 'denies access' do
            expect(subject.send(permission)).to be false
          end
        end

        context 'when user is admin (user-specific actions)' do
          subject { described_class.new(admin_user, user) }
          
          it 'denies access' do
            expect(subject.send(permission)).to be false
          end
        end
      end
    end
  end
end
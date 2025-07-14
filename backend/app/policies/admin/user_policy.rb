module Admin
  class UserPolicy < ApplicationPolicy
    def index?
      admin_user?
    end
    
    def show?
      admin_user?
    end
    
    def create?
      admin_user?
    end
    
    def update?
      admin_user?
    end
    
    def destroy?
      admin_user?
    end
    
    def balances?
      admin_user?
    end
    
    def adjust_balances?
      admin_user?
    end
    
    def redemptions?
      admin_user?
    end
    
    class Scope < Scope
      def resolve
        if admin_user?
          scope.all
        else
          scope.none
        end
      end
    end
  end
end
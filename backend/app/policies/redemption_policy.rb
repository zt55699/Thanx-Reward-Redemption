class RedemptionPolicy < ApplicationPolicy
  def index?
    user.present? # Require authentication
  end
  
  def create?
    user.present? && !admin_user? # Only regular users can create redemptions
  end
  
  class Scope < Scope
    def resolve
      if admin_user?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
class UserPolicy < ApplicationPolicy
  def show?
    owns_user_record?
  end
  
  def update?
    owns_user_record?
  end
  
  def balances?
    owns_user_record?
  end
  
  def redemptions?
    owns_user_record?
  end
  
  def create_redemption?
    owns_user_record?
  end

  private

  def owns_user_record?
    user == record
  end
end
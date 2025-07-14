class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  
  def create
    user = User.new(user_params)
    
    if user.save
      render_success({ user: user_json(user) }, :created)
    else
      render_error(user.errors.full_messages.join(", "))
    end
  end
  
  def show
    authorize current_user
    render_success({ user: user_json(current_user) })
  end
  
  def update
    authorize current_user
    
    if current_user.update(update_params)
      render_success({ user: user_json(current_user) })
    else
      render_error(current_user.errors.full_messages.join(", "))
    end
  end
  
  def balances
    authorize current_user
    render_success({
      points_balance: current_user.points_balance
    })
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
  
  def update_params
    params.require(:user).permit(:email, :name)
  end
end
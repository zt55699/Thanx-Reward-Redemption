module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :update, :destroy, :balances, :adjust_balances]
    
    def index
      authorize User, policy_class: Admin::UserPolicy
      users = policy_scope(User, policy_scope_class: Admin::UserPolicy::Scope)
      render_success({ users: users.map { |u| admin_user_json(u) } })
    end
    
    def show
      authorize @user, policy_class: Admin::UserPolicy
      render_success({ user: admin_user_json(@user) })
    end
    
    def create
      authorize User, policy_class: Admin::UserPolicy
      user = User.new(user_params)
      
      if user.save
        render_success({ user: admin_user_json(user) }, :created)
      else
        render_error(user.errors.full_messages.join(", "))
      end
    end
    
    def update
      authorize @user, policy_class: Admin::UserPolicy
      
      if @user.update(update_params)
        render_success({ user: admin_user_json(@user) })
      else
        render_error(@user.errors.full_messages.join(", "))
      end
    end
    
    def destroy
      authorize @user, policy_class: Admin::UserPolicy
      @user.destroy
      head :no_content
    end
    
    def balances
      authorize @user, policy_class: Admin::UserPolicy
      render_success({
        user_id: @user.id,
        points_balance: @user.points_balance
      })
    end
    
    def adjust_balances
      authorize @user, policy_class: Admin::UserPolicy
      
      # Use transaction and lock to prevent concurrent balance modifications
      ActiveRecord::Base.transaction do
        @user.with_lock do
          # Support both positive and negative adjustments
          if params[:points].present?
            @user.points_balance += params[:points].to_i
          end
          
          if @user.save
            render_success({
              user_id: @user.id,
              points_balance: @user.points_balance
            })
          else
            render_error(@user.errors.full_messages.join(", "))
          end
        end
      end
    end
    
    
    private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:email, :password, :name, :admin, :points_balance)
    end
    
    def update_params
      params.require(:user).permit(:email, :name, :admin)
    end
    
    def admin_user_json(user)
      {
        id: user.id,
        email: user.email,
        name: user.name,
        admin: user.admin,
        points_balance: user.points_balance,
        created_at: user.created_at
      }
    end
  end
end
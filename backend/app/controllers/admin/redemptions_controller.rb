module Admin
  class RedemptionsController < ApplicationController
    before_action :authenticate_user!
    
    def index
      authorize Redemption, policy_class: Admin::RedemptionPolicy
      
      redemptions = Redemption.includes(:user, :reward).order(created_at: :desc)
      
      # Filter by user if user_id param is provided
      redemptions = redemptions.where(user_id: params[:user_id]) if params[:user_id].present?
      
      render_serialized(redemptions, RedemptionSerializer, include: [:user, :reward])
    end
  end
end
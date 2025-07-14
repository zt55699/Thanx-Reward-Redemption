class RedemptionsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    redemptions = policy_scope(Redemption).includes(:reward).order(created_at: :desc)
    redemptions = redemptions.where(user_id: params[:user_id]) if params[:user_id].present?
    
    render_serialized(redemptions, RedemptionSerializer)
  end
  
  def create
    authorize Redemption, :create?
    
    redeemer = Rewards::Redeemer.new(
      user: current_user,
      reward_id: params[:reward_id]
    )
    
    result = redeemer.call
    
    if result[:success]
      render_serialized(
        result[:redemption], 
        RedemptionSerializer, 
        status: :created
      )
    else
      render_error(result[:error])
    end
  end
end
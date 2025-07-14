class RedemptionSerializer
  include JSONAPI::Serializer
  
  attributes :id, :created_at, :reward_name, :reward_description, :points_cost
  
  attribute :reward_name do |redemption|
    redemption.reward&.name
  end
  
  attribute :reward_description do |redemption|
    redemption.reward&.description
  end
  
  attribute :points_cost do |redemption|
    redemption.reward&.cost
  end
end
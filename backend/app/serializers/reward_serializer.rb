class RewardSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name, :description, :cost
end
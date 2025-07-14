require 'rails_helper'

RSpec.describe "Rewards", type: :request do
  describe "GET /rewards" do
    let!(:rewards) { create_list(:reward, 3) }

    it 'returns all rewards' do
      get '/rewards'
      
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json['data']).to be_an(Array)
      expect(json['data'].length).to eq(3)
      
      reward_data = json['data'].first
      expect(reward_data).to have_key('id')
      expect(reward_data).to have_key('attributes')
      expect(reward_data['attributes']).to have_key('name')
      expect(reward_data['attributes']).to have_key('description')
      expect(reward_data['attributes']).to have_key('cost')
    end
  end
end
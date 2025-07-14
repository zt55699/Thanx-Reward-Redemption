require 'rails_helper'

RSpec.describe "Redemptions", type: :request do
  let(:user) { create(:user, points_balance: 1000) }
  let(:reward) { create(:reward, cost: 500) }
  let(:headers) { { 'Authorization' => "Bearer #{generate_token(user)}" } }

  def generate_token(user)
    payload = { sub: user.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end

  describe "GET /redemptions" do
    let!(:redemptions) { create_list(:redemption, 2, user: user) }

    it 'returns user redemptions' do
      get '/redemptions', headers: headers
      
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json['data']).to be_an(Array)
      expect(json['data'].length).to eq(2)
    end

    it 'requires authentication' do
      get '/redemptions'
      
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /redemptions" do
    it 'creates a redemption when user has sufficient points' do
      expect {
        post '/redemptions', params: { reward_id: reward.id }, headers: headers
      }.to change { user.redemptions.count }.by(1)
      
      expect(response).to have_http_status(:created)
      
      user.reload
      expect(user.points_balance).to eq(500)
    end

    it 'returns error when user has insufficient points' do
      expensive_reward = create(:reward, cost: 1500)
      
      expect {
        post '/redemptions', params: { reward_id: expensive_reward.id }, headers: headers
      }.not_to change { user.redemptions.count }
      
      expect(response).to have_http_status(:unprocessable_entity)
      
      json = JSON.parse(response.body)
      expect(json['error']).to include('Insufficient points')
    end

    it 'requires authentication' do
      post '/redemptions', params: { reward_id: reward.id }
      
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
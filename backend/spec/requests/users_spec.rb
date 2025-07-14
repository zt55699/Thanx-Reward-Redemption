require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user, points_balance: 1500) }
  let(:headers) { { 'Authorization' => "Bearer #{generate_token(user)}" } }

  def generate_token(user)
    payload = { sub: user.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end

  describe "POST /user" do
    let(:user_params) do
      {
        user: {
          email: "newuser@thanx.com",
          password: "password123",
          name: "New User"
        }
      }
    end

    it 'creates a new user' do
      expect {
        post '/user', params: user_params
      }.to change { User.count }.by(1)
      
      expect(response).to have_http_status(:created)
      
      json = JSON.parse(response.body)
      expect(json['user']['email']).to eq('newuser@thanx.com')
      expect(json['user']['name']).to eq('New User')
    end
  end

  describe "GET /user" do
    it 'returns current user profile' do
      get '/user', headers: headers
      
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json['user']['id']).to eq(user.id)
      expect(json['user']['email']).to eq(user.email)
    end

    it 'requires authentication' do
      get '/user'
      
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /user/balances" do
    it 'returns user balances' do
      get '/user/balances', headers: headers
      
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json['points_balance']).to eq(1500)
    end

    it 'requires authentication' do
      get '/user/balances'
      
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
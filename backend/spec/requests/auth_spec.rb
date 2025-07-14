require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "POST /auth/login" do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      it 'returns a JWT token and user data' do
        post '/auth/login', params: { email: 'test@example.com', password: 'password123' }
        
        expect(response).to have_http_status(:success)
        
        json = JSON.parse(response.body)
        expect(json).to have_key('token')
        expect(json).to have_key('user')
        expect(json['user']['email']).to eq('test@example.com')
        expect(json['user']['name']).to eq(user.name)
        expect(json['user']['admin']).to eq(false)
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post '/auth/login', params: { email: 'test@example.com', password: 'wrong_password' }
        
        expect(response).to have_http_status(:unauthorized)
        
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Invalid email or password')
      end
    end

    context 'with non-existent user' do
      it 'returns unauthorized status' do
        post '/auth/login', params: { email: 'nonexistent@example.com', password: 'password123' }
        
        expect(response).to have_http_status(:unauthorized)
        
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Invalid email or password')
      end
    end
  end
end
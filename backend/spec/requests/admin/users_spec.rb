require 'rails_helper'

RSpec.describe "Admin Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:regular_user) { create(:user) }
  let(:admin_headers) { { 'Authorization' => "Bearer #{generate_token(admin)}" } }
  let(:user_headers) { { 'Authorization' => "Bearer #{generate_token(regular_user)}" } }

  def generate_token(user)
    payload = { sub: user.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end

  describe "GET /admin/users" do
    it 'returns all users for admin' do
      admin
      regular_user
      
      get '/admin/users', headers: admin_headers
      
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json['users']).to be_an(Array)
      expect(json['users'].length).to eq(2)
    end

    it 'denies access for regular users' do
      get '/admin/users', headers: user_headers
      
      expect(response).to have_http_status(:forbidden)
    end

    it 'requires authentication' do
      get '/admin/users'
      
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /admin/users/:id" do
    it 'returns specific user for admin' do
      get "/admin/users/#{regular_user.id}", headers: admin_headers
      
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json['user']['id']).to eq(regular_user.id)
      expect(json['user']['email']).to eq(regular_user.email)
    end

    it 'denies access for regular users' do
      get "/admin/users/#{regular_user.id}", headers: user_headers
      
      expect(response).to have_http_status(:forbidden)
    end
  end
end
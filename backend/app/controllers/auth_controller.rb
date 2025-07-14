class AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:email]&.downcase)
    
    if user&.authenticate(params[:password])
      token = generate_token(user)
      render_success({ token: token, user: user_json(user) })
    else
      render_error("Invalid email or password", :unauthorized)
    end
  end
  
  private
  
  def generate_token(user)
    payload = {
      sub: user.id, # Only store user ID - admin status verified from DB
      exp: 24.hours.from_now.to_i
    }
    # Use HS256 for simplicity in monolithic app
    JWT.encode(payload, Rails.application.secret_key_base, "HS256")
  end
end
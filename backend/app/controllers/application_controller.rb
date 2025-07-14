class ApplicationController < ActionController::API
  include Pundit::Authorization
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from JWT::DecodeError, with: :invalid_token
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  
  private
  
  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    
    if token
      # Verify JWT signature and decode - will raise JWT::DecodeError if invalid
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256")
      # Always fetch fresh user data from DB - ensures admin status is current
      @current_user = User.find(decoded[0]["sub"])
    else
      render json: { error: "Token missing" }, status: :unauthorized
    end
  end
  
  def current_user
    @current_user
  end
  
  def user_not_authorized
    render json: { error: "You are not authorized to perform this action" }, status: :forbidden
  end
  
  def invalid_token
    render json: { error: "Invalid token" }, status: :unauthorized
  end
  
  def not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  # Generic serialization method - centralizes JSONAPI formatting
  def render_serialized(resource, serializer_class, options = {})
    status = options[:status] || :ok
    
    serializer_options = {}
    serializer_options[:include] = options[:include] if options[:include]
    
    serialized_data = serializer_class.new(resource, serializer_options).serializable_hash
    render json: serialized_data, status: status
  end

  # User JSON helper for authentication responses
  def user_json(user)
    {
      id: user.id,
      email: user.email,
      name: user.name,
      admin: user.admin,
      created_at: user.created_at
    }
  end

  # Success response helper
  def render_success(data = {}, status = :ok)
    render json: data, status: status
  end

  # Error response helper
  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
end
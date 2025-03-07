class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token
  
  def encode_token(payload)
    JWT.encode(payload, ENV["JWT_SECRET_KEY"])
  end
  
  def decode_token
    auth_header = request.headers["Authorization"]
    if auth_header
      token = auth_header.split(" ").last
      begin
        JWT.decode(token, ENV["JWT_SECRET_KEY"], true, algorithm: "HS256")
      rescue JWT::DecodeError
        nil
      end
    end
  end
  
  def authorized_user
    decoded_token = decode_token()
    
    if decoded_token
      username = decoded_token[0]["username"]
      @user = User.where("BINARY username = ?", username).first
    end
  end
  
  def authorize
    render json: { message: "Você precisa estar logado" }, status: :unauthorized unless authorized_user
  end

  def access_denied(exception)
    # Redirecione para a página de login em vez de uma rota admin
    sign_out current_user if current_user
    redirect_to new_user_session_path, alert: exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end

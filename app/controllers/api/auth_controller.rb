class Api::AuthController < ApplicationController
  #include ActionController::MimeResponds
  before_action :authorize, only: [:info_user]
  
  def info_user
    percent_hits =  (@user.hits.to_f / @user.questions.to_f) * 100

    render json: {
      placar: {
        questoes: @user.questions,
        acertos: @user.hits,
        porcentagem: percent_hits
      }
    }
    
  end
  
  def login
    @user = User.find_by(username: params[:username])
    if @user&.valid_password?(params[:password])
      token = encode_token({ username: @user.username })
      render json: { user: @user, token: token }, status: :ok
    else
      render json: { message: "Username ou senha inválidos" }, status: :unauthorized
    end
  end

end
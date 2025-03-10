class Api::V1::AuthController < ApplicationController
  #include ActionController::MimeResponds
  before_action :authorize, only: [:info_user]
  
  def info_user
    percent_hits = @user.questions.zero? ? 0 : (@user.hits.to_f / @user.questions.to_f) * 100

    render json: {
      placar: {
        questoes: @user.questions,
        acertos: @user.hits,
        porcentagem: percent_hits
      }, status: 200
    }
    
  end
  
  def login
    @user = User.where("BINARY username = ?", params[:usuario]).first #Utilizado em virtude de ser case-sensitive diferente do find_by
    
    if @user&.valid_password?(params[:senha])
      return render json: {message: "Admin não pode jogar"} if @user.admin?
      token = encode_token({ username: @user.username })
      render json: {token: token}, status: :ok
    else
      render json: { message: "Username ou senha inválidos" }, status: :unauthorized
    end
  end

end
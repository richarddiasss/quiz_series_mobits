module AuthHelpers
  def encode_token(payload)
    # Este método deve reproduzir exatamente o mesmo comportamento 
    # do método encode_token em sua aplicação
    # Por exemplo:
    JWT.encode(payload, ENV['JWT_SECRET_KEY'] || 'your_test_secret')
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
      @user = User.find_by(username: username)
    end
  end
  
end
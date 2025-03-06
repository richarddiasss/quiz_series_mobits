module AuthHelpers
  def encode_token(payload)
    # Este método deve reproduzir exatamente o mesmo comportamento 
    # do método encode_token em sua aplicação
    # Por exemplo:
    JWT.encode(payload, ENV['JWT_SECRET_KEY'] || 'your_test_secret')
  end
end
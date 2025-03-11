
FactoryBot.define do
  factory :user do
    username {FFaker::Internet.user_name}
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    role { %w[admin jogador].sample }
    # adicione outros atributos necessários para o seu modelo User
  end
end
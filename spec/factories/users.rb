
FactoryBot.define do
  factory :user do
    username {FFaker::Internet.user_name}
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    role { %w[admin user].sample }
    # adicione outros atributos necessários para o seu modelo User
  end
end